//
//  RecordBookmark.swift
//  Paleo
//
//  Created by Joseph Zhu on 19/7/2022.
//

import SwiftUI

struct RecordBookmark: View {
    @EnvironmentObject private var modelData: ModelData
    @EnvironmentObject private var viewModel: MapViewModel
    @EnvironmentObject private var selectModel: RecordSelectModel
    @EnvironmentObject private var redFilterModel: RedFilterModel
    @Binding var currentTab: TabBarItem
    let record: Record

    private let textColorA: Color = .init(red:0.07, green:0.07, blue:0.07)
    private let textColorB: Color = .init(red:0.87, green:0.87, blue:0.87)
    
    struct SimpleButtonStyle: ButtonStyle {
        let size: CGSize
        
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .background(alignment: .center) {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(configuration.isPressed ? Color(red:0.1, green:0.1, blue:0.1) : Color(red:0.14, green:0.14, blue:0.14))
                        .frame(width: size.width, height: size.height)
                        .shadow(color: .black, radius: 3, x: 0, y: 4)
                }
        }
    }

    var body: some View {
        GeometryReader { [weak modelData, weak viewModel, weak selectModel, weak redFilterModel] proxy in
            if let modelData = modelData, let viewModel = viewModel, let selectModel = selectModel, let redFilterModel = redFilterModel {
                
                    ZStack {
                        ZStack {
                            Rectangle()
                                .fill(Color(red:0.8, green:0.8, blue:0.8))
                                .opacity(0.9)
                            
                            Image(systemName: record.icon)
                                .foregroundStyle(.ultraThinMaterial)
                                .font(.system(size: 120, weight: .bold))
                                .scaleEffect(CGSize(width: record.icon == "hare.fill" || record.icon == "fossil.shell.fill" || record.icon == "bird.fill" ? -1.0 : 1.0, height: 1.0))
                                .rotationEffect(.degrees(record.icon == "hurricane" ? -20.0 : 0.0))
                                .scaleEffect(CGSize(width: 1.0, height: 1.0))
                                .offset(x: 115, y: 20)
                                .symbolRenderingMode(.monochrome)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                                    .fill(.black)
                                
                                AsyncImage(url: URL(string: record.media[0])) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                                                    .fill(.black)
                                                
                                                image.resizable().scaledToFit()
                                            }
                                        case .failure:
                                            Text("")
                                        default:
                                            Text("")
                                        }
                                }
                            }
                            .frame(width: 160, height: 160)
                            .offset(x: -67.5 - 15)
                        }
                        .frame(width: 320, height: 80)
                        .cornerRadius(20.0)
                        .shadow(color: .black.opacity(0.88), radius: 4, y: 2)

                        Text("\(record.family)".capitalized)
                            .frame(width: 140, height: 60, alignment: .center)
                            .clipped()
                            .font(.system(size: 22, weight: .heavy)).foregroundColor(textColorA)
                            .scaledToFit()
                            .minimumScaleFactor(0.90)
                            .lineLimit(1)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                            .opacity(1.0)
                            .offset(x: 85 - 10, y: -35 + 6)
                        
                        Button(action: {
                            if !(modelData.filterDict[record.phylum] ?? true) {
                                redFilterModel.startRedAnimation()
                                return
                            }
                            
                            selectModel.freezeRecordsNearbyThenUpdate(coord: record.locationCoordinate, db: modelData.db, recordsTable: modelData.recordsTable, boxesTable: modelData.boxesTable, filter: modelData.filterDict)
                            viewModel.changeLocation(coord: record.locationCoordinate)
                            selectModel.updateSingleRecord(recordId: record.id, coord: record.locationCoordinate, db: modelData.db, recordsTable: modelData.recordsTable, isLikelyAnnotatedAlready: false)
                            selectModel.isDetailedMode = false
                            DispatchQueue.main.async {
                                currentTab = .map
                            }
                        }, label: {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(textColorB)
                                    .font(.system(size: 20))
                                    .offset(x: 13)
                                
                                VStack(spacing: -10) {
                                    Text("Lat: \(record.geoPoint.lat, specifier: "%.3f")")
                                        .frame(width: 115, height: 30, alignment: .leading)
                                        .clipped()
                                        .font(.system(size: 15, weight: .semibold)).foregroundColor(textColorB)
                                        .offset(x: 8)
                                    
                                    Text("Lon: \(record.geoPoint.lon, specifier: "%.3f")")
                                        .frame(width: 115, height: 30, alignment: .leading)
                                        .clipped()
                                        .font(.system(size: 15, weight: .semibold)).foregroundColor(textColorB)
                                        .offset(x: 8)
                                }
                            }
                        })
                        .offset(x: 77, y: 10)
                        .buttonStyle(SimpleButtonStyle(size: CGSize(width: 125, height: 50)))
                        
                    }
                
            }
        }
        .frame(width: 320, height: 100)
    }
}

struct RecordBookmark_Previews: PreviewProvider {
    static var previews: some View {
        RecordBookmark(currentTab: .constant(.search), record: Record(id: "c605530d-c733-4b90-b092-a1a6bc342e34", commonName: "", scientificName: "cephrenes augiades sperthias (c. felder, 1862)", phylum: .arthropoda, classT: "insecta", order: "lepidoptera", family: "Pieridae", locality: "sydney, lugarno", eventDate: "1981-10-22", media: ["https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012764.JPG", "https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012720.JPG"], geoPoint: GeoPoint(lat: -33.985112, lon: -151.043726)))
    }
}
