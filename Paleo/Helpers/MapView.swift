//
//  MapView.swift
//  Paleo
//
//  Created by Joseph Zhu on 30/4/2022.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(
                coordinateRegion: $viewModel.region,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: true,
                //userTrackingMode: $tracking
                annotationItems: modelData.records
            ) { record in
                MapMarker(coordinate: record.indexTerms.locationCoordinate)
            }
                .ignoresSafeArea()
                .accentColor(Color(.systemBlue))
                .onAppear {
                    viewModel.checkIfLocationServicesIsEnabled()
            }
            
            LocationButton {
                viewModel.requestAllowOnceLocationPermission()
            }
            .foregroundColor(.white)
            .cornerRadius(10)
            .labelStyle(.iconOnly)
            .symbolVariant(.fill)
            
            AsyncImage(url: URL(string: "https://www.hackingwithswift.com/img/paul-2.png")) { image in
                image.resizable()
            } placeholder: {
                Color.red
            }
            .frame(width: 128, height: 128)
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var records = ModelData().records
    
    static var previews: some View {
        MapView()
    }
}

