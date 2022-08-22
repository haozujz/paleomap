//
//  PaleoApp.swift
//  Paleo
//
//  Created by Joseph Zhu on 15/4/2022.
//

import SwiftUI

@main
struct PaleoApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
