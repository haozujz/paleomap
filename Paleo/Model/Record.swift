//
//  Record.swift
//  Paleo
//
//  Created by Joseph Zhu on 25/5/2022.
//

import Foundation
import CoreLocation
import SwiftUI

struct Record: Hashable, Codable, Identifiable {
    var id: String
    var commonName: String
    var scientificName: String
    var phylum: Phylum
    var classT: String
    var order: String
    var family: String
    var locality: String
    var eventDate: String

    var media: [String]
    var geoPoint: GeoPoint

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: geoPoint.lat,
            longitude: geoPoint.lon)
    }

    var icon: String {
        switch self.phylum {
        case .annelida: return "hurricane"
        case .archaeocyatha: return "aqi.medium"
        case .arthropoda: return "ant.fill"
            
        case .brachiopoda:
            if #available(iOS 16.0, *) {return "fossil.shell.fill"}
            else {return "seal.fill"}
        case .bryozoa: return "aqi.medium"
        case .chordata:
            switch self.classT {
            case "aves":
                if #available(iOS 16.0, *) {return "bird.fill"}
                else {return "hare.fill"}
            case "reptilia":
                if #available(iOS 16.0, *) {return "lizard.fill"}
                else {return "hare.fill"}
            case "actinopterygii", "sarcopterygii", "osteichthyes":
                if #available(iOS 16.0, *) {return "fish.fill"}
                else {return "hare.fill"}
            default: return "hare.fill"
            }
            
        case .cnidaria: return "snowflake"
        case .coelenterata: return "aqi.medium"
        case .echinodermata: return "staroflife.fill"
            
        case .mollusca:
            if #available(iOS 16.0, *) {return "fossil.shell.fill"}
            else {return "seal.fill"}
        case .platyhelminthes: return "hurricane"
        case .porifera: return "aqi.medium"
        }
    }
    
    var color: Color {
        switch self.phylum {
        case .annelida: return .brown
        case .archaeocyatha: return .blue
        case .arthropoda: return .purple
            
        case .brachiopoda: return .orange
        case .bryozoa: return .blue
        case .chordata:
            switch self.classT {
            case "aves": return .cyan
            case "reptilia": return .yellow
            case "actinopterygii", "sarcopterygii", "osteichthyes": return .indigo
            default: return .green
            }
            
        case .cnidaria: return .pink
        case .coelenterata: return .blue
        case .echinodermata: return .red
            
        case .mollusca: return .orange
        case .platyhelminthes: return .brown
        case .porifera: return .blue
        }
    }
}

//extension Record: Equatable {}
//
//func ==(lhs: Record, rhs: Record) -> Bool {
//    return lhs.id == rhs.id
//}
