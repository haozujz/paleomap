//
//  RecordSelectModel.swift
//  Paleo
//
//  Created by Joseph Zhu on 10/6/2022.
//

import Foundation
import MapKit
import SQLite

final class RecordSelectModel: ObservableObject {
    @Published var records: [Record] = []
    @Published var recordsNearby: [Record]? = nil
    @Published var isDetailedMode: Bool = false
    private var savedCoord = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    private var timer: Timer?
    private var isRecordsNearbyFrozen: Bool = false
    private let threshold: CGFloat = 0.01
    private let maxRecordsCount: Int = 15
    
    func updateRecordsSelection(coord: CLLocationCoordinate2D, db: Connection, recordsTable: Table, boxesTable: Table, filter: [Phylum : Bool], isIgnoreThreshold: Bool = false) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { [weak self] _ in
            guard let self = self else {return}
            
            if !isIgnoreThreshold && !self.isRecordsNearbyFrozen && (self.manhattanDistance(loc1: self.savedCoord, loc2: coord)) < self.threshold {
                return
            }
            let x = self.roundLat(lat: coord.latitude)
            let y = self.roundLon(lon: coord.longitude)
            let gridIndex: Int = Int(x * 3600 + y)
            self.records = self.getRecordsFromDbPerBox(centerIndex: gridIndex, db: db, recordsTable: recordsTable, boxesTable: boxesTable, filter: filter, coord: coord)
            self.savedCoord = coord
            
            if self.isRecordsNearbyFrozen {
                self.isRecordsNearbyFrozen = false
            } else {
                self.updateRecordsNearby()
            }
        }
    }
    
    func freezeRecordsNearbyThenUpdate(coord: CLLocationCoordinate2D, db: Connection, recordsTable: Table, boxesTable: Table, filter: [Phylum : Bool], isIgnoreThreshold: Bool = false) {
        isRecordsNearbyFrozen = true
        updateRecordsSelection(coord: coord, db: db, recordsTable: recordsTable, boxesTable: boxesTable, filter: filter, isIgnoreThreshold: isIgnoreThreshold)
    }
    
    func roundLat(lat: Double) -> Double {
        if lat == -90 {
            return 0
        }
        else {
            var x = ceil(lat * 10)
            x += 899
            return x
        }
    }

    func roundLon(lon: Double) -> Double {
        var x = ceil(lon * 10)
        if x <= 0 {
            x += 3599
        }
        else {
            x += -1
        }
        return x
    }

    func manhattanDistance(loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) -> Double {
        let xD = abs(loc1.latitude - loc2.latitude)
        let yD = abs(loc1.longitude - loc2.longitude)
        return xD + yD
    }
    
    func getRecordsFromDbPerBox(centerIndex: Int, db: Connection, recordsTable: Table, boxesTable: Table, filter: [Phylum : Bool], coord: CLLocationCoordinate2D) -> [Record] {
        let i = centerIndex
        let modifier: Array = [1,-1,-3600,-3601,-3599,3600,3599,3601]
        let modifier2: Array = [2,-2, -7200,-7201,-7202,-7199,-7198, 7200,7199,7198,7201,7202, -3602,-3598, 3598,3602]
        let modifier3: Array = [3, -3, -10800,-10801,-10802,-10803,-10799,-10798,-10797, 10800,10799,10798,10797,10801,10802,10803, -7203,-7197, -3603,-3597, 3597,3603, 7197,7203]
        
        var targets: [Int] = []
        var targets2: [Int] = []
        var targets3: [Int] = []
        
        var x: [Record] = []
        var x2: [Record] = []
        var x3: [Record] = []
        
        for m in modifier {
            let target = i+m
            if target < 0 || target > 6479999 {continue}
            targets.append(target)
        }
        x += queryDbPerBox(indexes: targets + [i], db: db, recordsTable: recordsTable, boxesTable: boxesTable)
        x = filterArray(array: x, filter: filter)
        
        if x.count < maxRecordsCount {
            for m in modifier2 {
                let target = i+m
                if target < 0 || target > 6479999 {continue}
                targets2.append(target)
            }
            x2 += queryDbPerBox(indexes: targets2, db: db, recordsTable: recordsTable, boxesTable: boxesTable)
            x2 = filterArray(array: x2, filter: filter)
            x.insert(contentsOf: x2, at: 0)
        }
        
        if x.count < maxRecordsCount {
            for m in modifier3 {
                let target = i+m
                if target < 0 || target > 6479999 {continue}
                targets3.append(target)
            }
            x3 += queryDbPerBox(indexes: targets3, db: db, recordsTable: recordsTable, boxesTable: boxesTable)
            x3 = filterArray(array: x3, filter: filter)
            x.insert(contentsOf: x3, at: 0)
        }
        
        x.sort {manhattanDistance(loc1: $0.locationCoordinate, loc2: coord) > manhattanDistance(loc1: $1.locationCoordinate, loc2: coord)}
        return Array(x.suffix(maxRecordsCount))
    }
    
    func updateRecordsNearby() {
        recordsNearby = Array(records.shuffled().prefix(5))
    }
    
    func updateSingleRecord(recordId: String, coord: CLLocationCoordinate2D, db: Connection, recordsTable: Table, isLikelyAnnotatedAlready: Bool) {
        if isLikelyAnnotatedAlready {
            if let record = records.first(where: {$0.id == recordId}) {
                recordsNearby = [record]
                return
            }
        }

        let id = Expression<String>("id")
        let sName = Expression<String?>("sName")
        let cName = Expression<String?>("cName")
        let phylum = Expression<String>("phylum")
        let classT = Expression<String?>("classT")
        let orderT = Expression<String?>("orderT")
        let family = Expression<String?>("family")
        let date = Expression<String?>("date")
        let locality = Expression<String?>("locality")
        let lat = Expression<Double>("lat")
        let lon = Expression<Double>("lon")
        let mediaS = Expression<String>("media")
        
        do {
            let query = recordsTable.filter(id == recordId).limit(1)
            
            for record in try db.prepare(query) {
                let phy: Phylum = Phylum(rawValue: record[phylum]) ?? .chordata
                let geo: GeoPoint = GeoPoint(lat: record[lat], lon: record[lon])
                let med: [String] = record[mediaS].components(separatedBy: "|")
                recordsNearby = [Record(id: record[id], commonName: record[cName] ?? "", scientificName: record[sName] ?? "", phylum: phy, classT: record[classT] ?? "", order: record[orderT] ?? "", family: record[family] ?? "", locality: record[locality] ?? "", eventDate: record[date] ?? "", media: med, geoPoint: geo)]
            }
        } catch {
            fatalError("Failed query:\n\(error)")
        }
    }
    
    func queryDbPerBox(indexes: [Int], db: Connection, recordsTable: Table, boxesTable: Table) -> [Record] {
        let idx = Expression<Int>("idx")
        let recordIds = Expression<String?>("recordIds")
        
        let id = Expression<String>("id")
        let sName = Expression<String?>("sName")
        let cName = Expression<String?>("cName")
        let phylum = Expression<String>("phylum")
        let classT = Expression<String?>("classT")
        let orderT = Expression<String?>("orderT")
        let family = Expression<String?>("family")
        let date = Expression<String?>("date")
        let locality = Expression<String?>("locality")
        let lat = Expression<Double>("lat")
        let lon = Expression<Double>("lon")
        let mediaS = Expression<String>("media")
        
        var idArray: [String] = []
        var x: [Record] = []
        
        do {
            let queryB = boxesTable.select(recordIds).filter(indexes.contains(idx))
            
            for box in try db.prepare(queryB) {
                idArray += box[recordIds]?.components(separatedBy: "|") ?? []
            }
            
            let queryR = recordsTable.filter((idArray).contains(id))
            
            for record in try db.prepare(queryR) {
                let phy: Phylum = Phylum(rawValue: record[phylum]) ?? .chordata
                let geo: GeoPoint = GeoPoint(lat: record[lat], lon: record[lon])
                let med: [String] = record[mediaS].components(separatedBy: "|")
                let r = Record(id: record[id], commonName: record[cName] ?? "", scientificName: record[sName] ?? "", phylum: phy, classT: record[classT] ?? "", order: record[orderT] ?? "", family: record[family] ?? "", locality: record[locality] ?? "", eventDate: record[date] ?? "", media: med, geoPoint: geo)
                x.append(r)
            }
        } catch {
            fatalError("Failed query:\n\(error)")
        }
        return x
    }
    
}

private func filterArray(array: [Record], filter: [Phylum : Bool]) -> [Record] {
    var x: [Record] = []
    array.forEach { record in
        if (filter[record.phylum]) ?? true {
            x.append(record)
        }
    }
    return x
}

//infix operator **
//
//func **(lhs: Double, rhs: Double) -> Double {
//    return pow(lhs, rhs)
//}
