//
//  RecordSelectModel.swift
//  Paleo
//
//  Created by Joseph Zhu on 10/6/2022.
//

import Foundation
import MapKit

final class RecordSelectModel: ObservableObject {
    @Published var records: [Record] = []
    @Published var recordsNearby: [Record]? = nil
    @Published var isDetailedMode: Bool = false
    private var savedCoord = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    private var timer: Timer?
    private var isRecordsNearbyFrozen: Bool = false
    private let threshold: CGFloat = 0.01 //0.08
    private let maxRecordsCount: Int = 20 //150

    func updateRecordsSelection(coord: CLLocationCoordinate2D, grid: [[Record]], filter: [Phylum : Bool], isIgnoreThreshold: Bool = false) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { [weak self] _ in
            guard let self = self else {return}
            
            if !isIgnoreThreshold && !self.isRecordsNearbyFrozen && (self.manhattanDistance(loc1: self.savedCoord, loc2: coord)) < self.threshold {
                return
            }
            let x = self.roundLat(lat: coord.latitude)
            let y = self.roundLon(lon: coord.longitude)
            let gridIndex: Int = Int(x * 3600 + y)
            self.records = self.getRecordsFromGrid(centerIndex: gridIndex, grid: grid, filter: filter, coord: coord)
            self.savedCoord = coord
            
            if self.isRecordsNearbyFrozen {
                self.isRecordsNearbyFrozen = false
            } else {
                self.updateRecordsNearby()
            }
        }
    }
    
    func freezeRecordsNearbyThenUpdate(coord: CLLocationCoordinate2D, grid: [[Record]], filter: [Phylum : Bool], isIgnoreThreshold: Bool = false) {
        isRecordsNearbyFrozen = true
        updateRecordsSelection(coord: coord, grid: grid, filter: filter, isIgnoreThreshold: isIgnoreThreshold)
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

    func getRecordsFromGrid(centerIndex: Int, grid: [[Record]], filter: [Phylum : Bool], coord: CLLocationCoordinate2D) -> [Record] {
        let i = centerIndex
        let modifier: Array = [1,-1,-3600,-3601,-3599,3600,3599,3601]
        let modifier2: Array = [2,-2, -7200,-7201,-7202,-7199,-7198, 7200,7199,7198,7201,7202, -3602,-3598, 3598,3602]
        let modifier3: Array = [3, -3, -10800,-10801,-10802,-10803,-10799,-10798,-10797, 10800,10799,10798,10797,10801,10802,10803, -7203,-7197, -3603,-3597, 3597,3603, 7197,7203]
        var x: [Record] = []
        var x2: [Record] = []
        var x3: [Record] = []
        
        for m in modifier {
            let target = i+m
            if target < 0 || target > 6479999 {continue}
            x += grid[target]
        }
        x += grid[i]
        x = filterArray(array: x, filter: filter)
        
        if x.count < maxRecordsCount {
            for m in modifier2 {
                let target = i+m
                if target < 0 || target > 6479999 {continue}
                x2 += grid[target]
            }
            x2 = filterArray(array: x2, filter: filter)
            x.insert(contentsOf: x2, at: 0)
        }
        
        if x.count < maxRecordsCount {
            for m in modifier3 {
                let target = i+m
                if target < 0 || target > 6479999 {continue}
                x3 += grid[target]
            }
            x3 = filterArray(array: x3, filter: filter)
            x.insert(contentsOf: x3, at: 0)
        }
        
        x.sort {manhattanDistance(loc1: $0.locationCoordinate, loc2: coord) > manhattanDistance(loc1: $1.locationCoordinate, loc2: coord)}
        return Array(x.suffix(maxRecordsCount))
    }
    
    func updateRecordsNearby() {
        recordsNearby = Array(records.shuffled().prefix(5))
    }
    
    func updateSingleRecord(id: String, coord: CLLocationCoordinate2D, grid: [[Record]], isLikelyAnnotatedAlready: Bool) {
        if isLikelyAnnotatedAlready {
            if let record = records.first(where: {$0.id == id}) {
                recordsNearby = [record]
                return
            }
        }
        
        let x = roundLat(lat: coord.latitude)
        let y = roundLon(lon: coord.longitude)
        let gridIndex: Int = Int(x * 3600 + y)
        
        if let record = grid[gridIndex].first(where: {$0.id == id}) {
            recordsNearby = [record]
            return
        }
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
