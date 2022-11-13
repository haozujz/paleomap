//
//  ModelData.swift
//  Paleo
//
//  Created by Joseph Zhu on 25/5/2022.
//

import Foundation
import Combine
import SwiftUI
import SQLite

final class ModelData: ObservableObject {
    var bookmarked: [Record] = [] {
        didSet {
            objectWillChange.send()
            
            var x: [String] = []
            bookmarked.forEach { record in
                x.append(record.id)
            }
            UserDefaults.standard.set(x, forKey: "bookmarkedIDs")
        }
    }
    
    var filterDict: [Phylum : Bool]
    let db: Connection
    let recordsTable: SQLite.Table
    let boxesTable: SQLite.Table
    
    init() {
        //intialize db, recordsTable, boxesTable
        do {
            let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite")!
            self.db = try Connection(dbPath, readonly: true)
            self.recordsTable = SQLite.Table("records")
            self.boxesTable = SQLite.Table("boxes")
        } catch {
            fatalError("Couldn't load db.sqlite from main bundle:\n\(error)")
        }

        //initialize filterDict
        var x: [Phylum : Bool] = [:]
        var dict = UserDefaults.standard.dictionary(forKey: "filterDict") as? [String : Bool] ?? [:]
        
        if dict == [:] {
            var y: [String : Bool] = [:]
            Phylum.allCases.forEach { phylum in
                y[phylum.rawValue] = true
            }
            UserDefaults.standard.set(y, forKey: "filterDict")
            dict = y
        }
        for (k, v) in dict {
            x[Phylum(rawValue: k)!] = v
        }
        self.filterDict = x
        
        // initialize bookmarked
        var z: [Record] = []
        let bookmarkedIDs: [String] = UserDefaults.standard.array(forKey: "bookmarkedIDs") as? [String] ?? []
        
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
            let query = recordsTable.filter((bookmarkedIDs).contains(id))
            
            for record in try db.prepare(query) {
                let phy: Phylum = Phylum(rawValue: record[phylum]) ?? .chordata
                let geo: GeoPoint = GeoPoint(lat: record[lat], lon: record[lon])
                let med: [String] = record[mediaS].components(separatedBy: "|")
                let r = Record(id: record[id], commonName: record[cName] ?? "", scientificName: record[sName] ?? "", phylum: phy, classT: record[classT] ?? "", order: record[orderT] ?? "", family: record[family] ?? "", locality: record[locality] ?? "", eventDate: record[date] ?? "", media: med, geoPoint: geo)
                z.append(r)
            }
        } catch {
            fatalError("Failed intializing bookmarks:\n\(error)")
        }
        self.bookmarked = z
    }
}

//func load<T: Decodable>(_ filename: String) -> T {
//    let data: Data
//
//    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
//    else {
//        fatalError("Couldn't find \(filename) in main bundle.")
//    }
//
//    do {
//        data = try Data(contentsOf: file)
//    } catch {
//        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
//    }
//
//    do {
//        let decoder = JSONDecoder()
//        return try decoder.decode(T.self, from: data)
//    } catch {
//        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
//    }
//}
