//
//  TabBarItem.swift
//  Paleo
//
//  Created by Joseph Zhu on 6/7/2022.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable, CaseIterable {
    case search, map, filter
    
    var icon: String {
        switch self {
        case .search: return "magnifyingglass"
        case .map: return "map"
        case .filter: return "line.3.horizontal"
        }
    }
}


