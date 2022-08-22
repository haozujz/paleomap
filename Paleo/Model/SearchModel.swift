//
//  SearchModel.swift
//  Paleo
//
//  Created by Joseph Zhu on 22/7/2022.
//

import Foundation
import SwiftUI

final class SearchModel: ObservableObject {
    @Published var isSearching: Bool = false
    @Published var lastSubmittedText: String = ""
    var lastCompletedSearch: String = ""

    enum AbortEvent: Equatable { case cancel, search }
    private var abortKey: Int = 0
    var results: [Record] = []
    
    @Published var searchText: String = ""
    
    func search(grid: [[Record]]) {
        logSearchEvent()
        isSearching = true
        
        lastSubmittedText = searchText.capitalized
        let submittedText: String = searchText.lowercased()
        let savedAbortKey: Int = abortKey
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + 0.1, execute: { [weak self] in
            guard let self = self else {return}
            
            var x: [Record] = []
            
            for box in grid {
                if savedAbortKey != self.abortKey { break }
                x += box.filter{ self.filterProcess(record: $0, submittedText: submittedText) }
            }
            if savedAbortKey == self.abortKey { x.sort {$0.family < $1.family} }
            
            DispatchQueue.main.async {
                //print("abortKey: \(self.abortKey)")
                //print("savedAbortKey: \(savedAbortKey)")
                if savedAbortKey == self.abortKey {
                    self.results = x
                    self.lastCompletedSearch = submittedText.capitalized
                    self.isSearching = false
                }
            }
        })
    }
    
    func filterProcess(record: Record, submittedText: String) -> Bool {
        let terms: [String] = [record.scientificName, record.commonName, record.phylum.rawValue, record.order, record.classT, record.family]
        return terms.contains(submittedText)
    }
    
    func logSearchEvent() {
        if abortKey < 1000 { abortKey += 1 }
        else { abortKey = 0 }
    }
}
