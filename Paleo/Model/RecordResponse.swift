//
//  Record.swift
//  Paleo
//
//  Created by Joseph Zhu on 19/4/2022.
//

import Foundation
import CoreLocation

struct RecordResponse: Decodable {
    let items: [Record]
}

struct Record: Decodable, Identifiable {
    let uuid: String
    var id: String { uuid }
    let indexTerms: IndexTerms
    
    struct IndexTerms: Decodable {
        let scientificname: String
        let highertaxon: String
        let phylum: String
        let locality: String
        let institutioncode: String?
        let catalognumber: String?
        let datecollected: String  
        let mediarecords: [String]
        
        let geopoint: Geopoint
        var locationCoordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(
                latitude: geopoint.lat,
                longitude: geopoint.lon)
        }
        
        struct Geopoint: Hashable, Codable {
            let lat: Double
            let lon: Double
        }
    }
}




