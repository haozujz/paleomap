//
//  PaleoApp.swift
//  Paleo
//
//  Created by Joseph Zhu on 23/5/2022.
//

import SwiftUI

@main
struct PaleoApp: App {
    @StateObject var modelData = ModelData()
    @StateObject var viewModel = MapViewModel()
    @StateObject var selectModel = RecordSelectModel()
    @StateObject var imageModel = ImageModel()
    @StateObject var searchModel = SearchModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .ignoresSafeArea()
                    .environmentObject(modelData)
                    .environmentObject(viewModel)
                    .environmentObject(selectModel)
                    .environmentObject(imageModel)
                    .environmentObject(searchModel)
            }
        }
    }
}
