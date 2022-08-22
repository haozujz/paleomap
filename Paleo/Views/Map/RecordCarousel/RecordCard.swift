//
//  RecordCard.swift
//  Paleo
//
//  Created by Joseph Zhu on 12/6/2022.
//

import SwiftUI
import MapKit

struct RecordCard: View {
    @EnvironmentObject private var modelData: ModelData
    @EnvironmentObject private var viewModel: MapViewModel
    @EnvironmentObject private var selectModel: RecordSelectModel
    var record: Record

    @State private var isShowAlert: Bool = false
    private var data: [String] {
        [record.scientificName, record.commonName, record.phylum.rawValue, record.order, record.classT, record.family, record.eventDate, record.locality]
    }
    private let offsetPerScreen: CGFloat = -0.25 * (UIScreen.main.bounds.size.width - 320)
    private let textColorA: Color = .init(red:0.07, green:0.07, blue:0.07)
    private let textColorB: Color = .init(red:0.87, green:0.87, blue:0.87)
    private let subtitles: [String] = ["Scientific\nName", "Common\nName", "Phylum", "Order", "Class", "Family", "Event\nDate", "Locality", "Coord"]
    
    struct SimpleButtonStyle: ButtonStyle {
        var size: CGSize
        
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .background(alignment: .center) {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(configuration.isPressed ? Color(red:0.1, green:0.1, blue:0.1) : Color(red:0.2, green:0.2, blue:0.2))
                        .frame(width: size.width, height: size.height)
                        .shadow(color: .black, radius: 2, x: 0, y: 3)
                }
        }
    }

    var body: some View {
        GeometryReader { [weak modelData, weak viewModel, weak selectModel] proxy in
            if let modelData = modelData, let viewModel = viewModel, let selectModel = selectModel {
                
                ZStack {
                    ZStack {
                        Rectangle()
                            .fill(Color(red:0.8, green:0.8, blue:0.8))
                            .frame(width: 320, height: selectModel.isDetailedMode ? 570 : 170)
                            .opacity(0.9)
                        
                        Image(systemName: record.icon)
                            .foregroundStyle(.ultraThinMaterial)
                            .font(.system(size: 120, weight: .bold))
                            .scaleEffect(CGSize(width: record.icon == "hare.fill" || record.icon == "fossil.shell.fill" || record.icon == "bird.fill" ? -1.0 : 1.0, height: 1.0))
                            .rotationEffect(.degrees(record.icon == "hurricane" ? -20.0 : 0.0))
                            .scaleEffect(CGSize(width: selectModel.isDetailedMode ? 1.9 : 1.0, height: selectModel.isDetailedMode ? 1.9 : 1.0))
                            .offset(x: 115, y: selectModel.isDetailedMode ? 150 : 50)
                            .symbolRenderingMode(.monochrome)
                        
                        ZStack(alignment: .center) {
                            ForEach(0...8, id: \.self) { idx in
                                let i: CGFloat = CGFloat(idx)
                                
                                if subtitles[idx].contains("\n") {
                                    Text(subtitles[idx])
                                        .font(.system(size: 15, weight: .bold))
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                                        .offset(y: 41 * (i - 1))
                                } else {
                                    Text(subtitles[idx])
                                        .lineLimit(1)
                                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                                        .offset(y: 41 * (i - 1))
                                }
                            }
                        }
                        .font(.system(size: 16, weight: .bold)).foregroundColor(textColorB)
                        .offset(y: -32)
                        .background(alignment: .center) {
                            Color(red:0.1, green:0.1, blue:0.1)
                                .frame(width: 95, height: selectModel.isDetailedMode ? 570 : 170)
                                .shadow(color: .black, radius: selectModel.isDetailedMode ? 4 : 0, x: selectModel.isDetailedMode ? 2 : 0, y: 0)
                        }
                        .offset(x: selectModel.isDetailedMode ? -115 : -220)
                        
                        ZStack(alignment: .center) {
                            ForEach(0...7, id: \.self) { idx in
                                let i: CGFloat = CGFloat(idx)

                                Text(data[idx].capitalized)
                                    .lineLimit(1)
                                    .frame(width: 210)
                                    .offset(y: 41 * (i - 1))
                            }
                        }
                        .font(.system(size: 17, weight: .bold)).foregroundColor(.black)
                        .offset(y: -32)
                        .offset(x: selectModel.isDetailedMode ? 45 : -270)
                    }
                    .frame(width: 320, height: selectModel.isDetailedMode ? 570 : 170)
                    .cornerRadius(15.0)
                    .shadow(color: .black, radius: 4, y: 2)

                    Text("\(record.family)".capitalized)
                        .frame(width: 140, height: 60, alignment: .center)
                        .clipped()
                        .font(.system(size: 22, weight: .heavy)).foregroundColor(textColorA)
                        .scaledToFit()
                        .minimumScaleFactor(0.90)
                        .lineLimit(1)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                        .opacity(selectModel.isDetailedMode ? 0.0 : 1.0)
                        .offset(x: 87, y: -65)
                    
                    Text("\(record.locality)".capitalized)
                        .frame(width: 130, height: 30, alignment: .center)
                        .clipped()
                        .font(.system(size: 18, weight: .semibold)).foregroundColor(textColorA)
                        .scaledToFit()
                        .minimumScaleFactor(0.90)
                        .lineLimit(2)
                        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                        .opacity(selectModel.isDetailedMode ? 0.0 : 1.0)
                        .offset(x: 90, y: -27)
                    
                    Button(action: {
                        if modelData.bookmarked.count > 99 {
                            isShowAlert = true
                            return
                        }
                        
                        if modelData.bookmarked.contains(record) {
                            modelData.bookmarked = modelData.bookmarked.filter{ $0.id != record.id }
                        } else {
                            modelData.bookmarked.append(record)
                        }
                    }, label: {
                        Image(systemName: modelData.bookmarked.contains{ $0.id == record.id } ? "bookmark.fill" : "bookmark")
                            .foregroundColor(textColorB)
                            .font(.system(size: 25, weight: .bold))
                    })
                    .opacity(selectModel.isDetailedMode ? 1.0 : 0.0)
                    .buttonStyle(SimpleButtonStyle(size: CGSize(width: 40, height: 40)))
                    .offset(x: selectModel.isDetailedMode ? 111 : 134, y: selectModel.isDetailedMode ? 257 : 24)
                    .alert("Alert", isPresented: $isShowAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Maximum bookmarks reached")
                    }
                    
                    Button(action: {
                        selectModel.freezeRecordsNearbyThenUpdate(coord: record.locationCoordinate, grid: modelData.grid, filter: modelData.filterDict)
                        viewModel.changeLocation(coord: record.locationCoordinate)
                        selectModel.isDetailedMode = false
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
                    .buttonStyle(SimpleButtonStyle(size: CGSize(width: 125, height: 50)))
                    .offset(x: selectModel.isDetailedMode ? 46 - 23 : 87, y: selectModel.isDetailedMode ? 256 : 24)
                    
                    ImageCarousel(media: record.media)
                        .shadow(color: .black, radius: 4, y: 3)
                        .offset(x: selectModel.isDetailedMode ? offsetPerScreen + proxy.frame(in: .global).origin.x * 0.5 : -67.5 + offsetPerScreen + proxy.frame(in: .global).minX * 0.5, y: selectModel.isDetailedMode ? -245 : -20)
                        .allowsHitTesting(selectModel.isDetailedMode)
                } 
                
            }
            
                 
        }
        .frame(width: 320, height: 170)
            
    }
}

struct RecordCard_Previews: PreviewProvider {

    static var previews: some View {
        RecordCard(record:
                    Record(id: "c605530d-c733-4b90-b092-a1a6bc342e34", basisOfRecord: "preservedspecimen", commonName: "", scientificName: "cephrenes augiades sperthias (c. felder, 1862)", phylum: .arthropoda, classT: "insecta", order: "lepidoptera", family: "Pieridae", locality: "sydney, lugarno", eventDate: "1981-10-22", media: ["https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012764.JPG", "https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012720.JPG"], geoPoint: Record.GeoPoint(lat: -33.985112, lon: 151.043726))
        )
    }
}
