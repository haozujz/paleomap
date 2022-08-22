//
//  Phylum.swift
//  Paleo
//
//  Created by Joseph Zhu on 16/7/2022.
//

import Foundation
import SwiftUI

enum Phylum: String, Codable, CaseIterable {
    case annelida = "annelida"
    case archaeocyatha = "archaeocyatha"
    case arthropoda = "arthropoda"
    
    case brachiopoda = "brachiopoda"
    case bryozoa = "bryozoa"
    case chordata = "chordata"
    
    case cnidaria = "cnidaria"
    case coelenterata = "coelenterata"
    case echinodermata = "echinodermata"
    
    case mollusca = "mollusca"
    case platyhelminthes = "platyhelminthes"
    case porifera = "porifera"
}
