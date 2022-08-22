//
//  ModelData.swift
//  Paleo
//
//  Created by Joseph Zhu on 25/5/2022.
//

import Foundation
import Combine
import SwiftUI

final class ModelData: ObservableObject {
    @Published var grid: [[Record]] = load("recordsData.json")
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
    
    init() {
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
        
        var z: [Record] = []
        let bookmarkedIDS: [String] = UserDefaults.standard.array(forKey: "bookmarkedIDs") as? [String] ?? []
        
        for box in grid {
            for record in box {
                if bookmarkedIDS.contains(record.id) {
                    z.append(record)
                }
            }
        }
        self.bookmarked = z
    }
    
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Coudln't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
