//
//  MapView.swift
//  Paleo
//
//  Created by Joseph Zhu on 25/5/2022.
//

import SwiftUI
import MapKit
import CoreLocationUI
import Combine

struct MapView: View {
    @EnvironmentObject private var modelData: ModelData
    @EnvironmentObject private var viewModel: MapViewModel
    @EnvironmentObject private var selectModel: RecordSelectModel
    
    @State private var isLocationServicesChecked: Bool = false
    //@State private var trackingMode: MapUserTrackingMode = .follow
    
    struct MapAnnotationView: View {
        let color: Color
        let icon: String
        
        var body: some View {
            ZStack {
                Image(systemName: "circle.fill")
                    .foregroundColor(color)
                    .saturation(0.6)
                    .font(.system(size: 35))
                Image(systemName: icon)
                    .foregroundColor(Color.init(red:0.1, green:0.1, blue:0.1))
                    .scaleEffect(CGSize(width: icon == "hare.fill" || icon == "fossil.shell.fill" || icon == "bird.fill" ? -1.0 : 1.0, height: 1.0))
                    .scaleEffect(icon == "seal.fill" ? 0.8 : 1.0)
                    .rotationEffect(.degrees(icon == "hurricane" ? -20.0 : 0.0))
                    .font(.system(size: icon == "hare.fill" || icon == "ant.fill" ? 20 : 25, weight: icon == "seal.fill" ? .thin : .bold))
                    .offset(y: icon == "hare.fill" || icon == "ant.fill" ? -1 : 0)
            }
            .symbolRenderingMode(.monochrome)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) { //[weak modelData, weak viewModel, weak selectModel] in
            //if let modelData = modelData, let viewModel = viewModel, let selectModel = selectModel {//
                
                Map(
                    coordinateRegion: $viewModel.region,
                    interactionModes: MapInteractionModes.all,
                    showsUserLocation: true,
                    //userTrackingMode: $trackingMode,
                    annotationItems: selectModel.records
                ) { record in
                    MapAnnotation(coordinate: record.locationCoordinate) {
                        MapAnnotationView(color: record.color, icon: record.icon)
                            .onTapGesture {
                                selectModel.updateSingleRecord(recordId: record.id, coord: record.locationCoordinate, db: modelData.db, recordsTable: modelData.recordsTable, isLikelyAnnotatedAlready: true)
                            }
                    }
                }
                .onAppear {
                    if !isLocationServicesChecked {
                        viewModel.checkIfLocationServicesIsEnabled()
                        isLocationServicesChecked = true
                    }
                }
                .onChange(of: viewModel.region.center) { _ in
//                    DispatchQueue.global(qos: .userInteractive).async {
//                        selectModel.updateRecordsSelection(coord: viewModel.region.center, db: modelData.db, recordsTable: modelData.recordsTable, boxesTable: modelData.boxesTable, filter: modelData.filterDict)
//                    }
                    selectModel.updateRecordsSelection(coord: viewModel.region.center, db: modelData.db, recordsTable: modelData.recordsTable, boxesTable: modelData.boxesTable, filter: modelData.filterDict)
                }
                .alert("Alert", isPresented: $viewModel.isShowAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(viewModel.alertMessage)
                }
                
                if selectModel.recordsNearby?.isEmpty ?? true {
                    ZStack {
                        Rectangle()
                            .fill(Color(red:0.8, green:0.8, blue:0.8))
                            .frame(width: 320, height: 170)
                            .opacity(0.9)
                        
                        Image(systemName: "exclamationmark.triangle.fill")
                            .clipped()
                            .foregroundStyle(.ultraThinMaterial)
                            .font(.system(size: 120, weight: .bold))
                            .offset(x: 115, y: 0)
                            .symbolRenderingMode(.monochrome)
                        
                        Text("No nearby records")
                            .font(.system(size: 22, weight: .heavy)).foregroundColor(Color(red:0.07, green:0.07, blue:0.07))
                            .lineLimit(1)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                            .offset(x: 0, y: 0)
                    }
                    .cornerRadius(15.0)
                    .shadow(color: .black.opacity(0.92), radius: 4, y: 2)
                    .offset(y: -110)
                }

                RecordCarousel()
                    .offset(y: -35)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .frame(width: UIScreen.main.bounds.size.width > 600 ? 320 : UIScreen.main.bounds.size.width, alignment: .center)
                    .clipped()
        
            //}//
            
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(MapViewModel())
            .environmentObject(RecordSelectModel())
            .environmentObject(ImageModel())
    }
}

