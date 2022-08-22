//
//  Carousel.swift
//  Paleo
//
//  Created by Joseph Zhu on 10/6/2022.
//
//
//import Foundation
//import SwiftUI
//
//struct Carousel<Content: View, T: Identifiable>: View {
//    var content: (T, Binding<CGFloat>) -> Content
//    var list: [T]
//
//    var spacing: CGFloat
//    var trailingSpace: CGFloat
//    @Binding var currentIndex: Int
//
//    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 65, currentIndex: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T, Binding<CGFloat>)->Content){
//        self.list = items
//        self.spacing = spacing
//        self.trailingSpace = trailingSpace
//        self._currentIndex = currentIndex
//        self.content = content
//    }
//
//    @GestureState var offset = CGPoint(x:0, y:0)
//    @State var index: Int = 0
//
//    @State private var horizontal = true
//    @State private var vertical = true
//
//    @State private var yOffset: CGFloat = 0
//
//    var body: some View {
//        GeometryReader { proxy in
//            let width = proxy.size.width - (trailingSpace - spacing)
//            let adjustmentWidth = (trailingSpace / 2) - spacing
//
//            HStack(spacing: spacing) {
//                ForEach(list){item in
//                    content(item, $yOffset)
//                        .frame(width: proxy.size.width - trailingSpace, height: 100)
//                }
//            }
//            .padding(.horizontal,spacing)
//            .offset(x: (CGFloat(currentIndex) * -width) + adjustmentWidth + offset.x, y: offset.y<0 ? offset.y : 0)
//            .simultaneousGesture(
//                DragGesture()
//                    .updating($offset, body: { value, out, _ in
//                        if self.horizontal && !self.vertical {
//                            out.x = value.translation.width
//                        } else if !self.horizontal && self.vertical{
//                            out.y = value.translation.height
//
//                            //modifiying state during view update causes undefined behaviour
//                            //yOffset = value.translation.height
//                        }
//                    })
//                    .onChanged({ value in
//                        let x = value.translation.width
//                        let y = value.translation.height
//
//                        if self.horizontal && self.vertical && (x > 5 || x < -5 || y < -5)  {
//                            if abs(x) >= y * -1 {
//                                self.horizontal = true
//                                self.vertical = false
//                            } else {
//                                self.horizontal = false
//                                self.vertical = true
//                            }
//                        }
//
//                        if self.horizontal && !self.vertical {
//                            let xOffset = value.translation.width
//                            let progress = -xOffset / width
//                            let roundIndex = progress.rounded()
//                            index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
//                        } else if !self.horizontal && self.vertical  {
//                            yOffset = value.translation.height
//                        }
//                    })
//                    .onEnded({ value in
//                        if self.horizontal {
//                            let xOffset = value.translation.width
//                            let progress = -xOffset / width
//                            let roundIndex = progress.rounded()
//                            currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
//                            currentIndex = index
//                        } else {
//                            yOffset = 0
//                        }
//                        self.horizontal = true
//                        self.vertical = true
//                    })
//            )
//        }
//        .animation(.easeInOut, value: offset == CGPoint(x:0,y:0))
//    }
//
//    func updateCurrentIndex() {
//        currentIndex = 0
//    }
//}


// Preview for parent container if passing [Record]
//        RecordCarousel(recordsNearby:
//                        [Record(id: "c605530d-c733-4b90-b092-a1a6bc342e34", basisOfRecord: "preservedspecimen", commonName: "", scientificName: "cephrenes augiades sperthias (c. felder, 1862)", phylum: .arthropoda, classT: "insecta", order: "lepidoptera",  family: "Pieridae", locality: "sydney, lugarno", eventDate: "1981-10-22", media: ["https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012764.JPG", "https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012720.JPG"], geoPoint: Record.GeoPoint(lat: -33.985112, lon: 151.043726)), Record(id: "2a073217-44c1-46c4-b76c-e4ee5ca66286", basisOfRecord: "preservedspecimen", commonName: "spotted quail-thrush; perching birds; birds; vertebrates; chordates; animals", scientificName: "cinclosoma punctatum punctatum", phylum: .chordata, classT: "aves", order: "passeriformes", family: "Pieridae", locality: "", eventDate: "1917-09-29", media: ["https://images.collections.yale.edu/iiif/2/ypm:7c1403f0-eae7-4f39-ad20-34f9857e6d16/full/!1920,1920/0/default.jpg", "https://images.collections.yale.edu/iiif/2/ypm:5576300f-38dd-488c-a5c1-f5676aa53956/full/!1920,1920/0/default.jpg", "https://images.collections.yale.edu/iiif/2/ypm:fbc8b5e8-a0de-4d47-bb5f-caf85dc4f373/full/full/0/default.jpg", "https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=b6d6ed3d-e36b-4b1d-a951-515183455a8e", "https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=7557297a-173e-45c3-a2aa-819dd6189984", "https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=12e4c2ad-abcb-4052-80d8-ab266f2d6d35", "https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=9485d959-fbcf-4b38-853b-c6aa848b7116"], geoPoint: Record.GeoPoint(lat: -33.7, lon: 151.1)), Record(id: "5e1fb105-b84d-4988-8274-892201e73826", basisOfRecord: "preservedspecimen", commonName: "orchid snail", scientificName: "zonitoides arboreus", phylum: .mollusca, classT: "gastropoda", order: "stylommatophora", family: "Pieridae", locality: "", eventDate: "1864", media: ["https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=cab86577-7d24-49fb-af8b-6254a9ff45cb"], geoPoint: Record.GeoPoint(lat: -33.87971, lon: 151.18999)), Record(id: "764c9888-a49b-466a-be93-971f62cdff8e", basisOfRecord: "preservedspecimen", commonName: "", scientificName: "hesperilla picta (leach, 1814)", phylum: .arthropoda, classT: "insecta", order: "lepidoptera", family: "Pieridae", locality: "dural", eventDate: "1989-11-20", media: ["https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_06_24/IMG_010716.JPG", "https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2010_04_12/IMG_040060.JPG", "https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2010_04_12/IMG_040062.JPG", "https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2010_04_12/IMG_040061.JPG", "https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2010_03_11/IMG_035602.JPG"], geoPoint: Record.GeoPoint(lat: -33.6818, lon: 151.0262)), Record(id: "b1f06b00-b1d7-4eeb-a740-af76a8fd817e", basisOfRecord: "preservedspecimen", commonName: "", scientificName: "guraleus pictus", phylum: .mollusca, classT: "gastropoda", order: "hypsogastropoda", family: "Pieridae", locality: "port jackson", eventDate: "", media: ["https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=97a16525-97c5-4263-9014-8dbeaca51c66", "https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=814adaeb-c9f3-4053-8751-b433b2289820", "https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=27c57061-f432-4117-9dfb-3227dcd4fc3f", "https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=8a9d68fe-d225-4da4-8e2f-dff76ac87779", "https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=26e22c41-551f-40c5-9146-4346065cadf7", "https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=9d2ee175-0545-4ad2-995c-9a298e9beeda"], geoPoint: Record.GeoPoint(lat: -33.85, lon: 151.27))]
//        )
