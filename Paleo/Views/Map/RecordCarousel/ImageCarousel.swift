//
//  RecordImage.swift
//  Paleo
//
//  Created by Joseph Zhu on 20/6/2022.
//

import SwiftUI

struct ImageCarousel: View {
    @EnvironmentObject private var selectModel: RecordSelectModel
    var media: [String]

    @State private var currentIndex: Int = 0
    private let maxSize: CGFloat = 280
    private let minSize: CGFloat = 160
    
    var body: some View {
        ZStack { [weak selectModel] in
            if let selectModel = selectModel {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.black)
                    .opacity(selectModel.isDetailedMode ? 0.0 : 0.1)
                    .frame(width: selectModel.isDetailedMode ? maxSize : minSize, height: selectModel.isDetailedMode ? maxSize : minSize, alignment: .center)
                    .onTapGesture {
                        selectModel.isDetailedMode = true
                    }
                
                CarouselH(currentIndex: $currentIndex, items: media) { url  in
                    ImageCell(url: url)
                }
                .allowsHitTesting(selectModel.isDetailedMode)
                .offset(y: 30)
                .frame(width: selectModel.isDetailedMode ? maxSize : minSize, height: selectModel.isDetailedMode ? maxSize : minSize, alignment: .center)
                .clipped()
                
                if media.count > 1 && selectModel.isDetailedMode {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.thinMaterial)
                            .frame(width: CGFloat(media.count) * 15, height: 20, alignment: .center)
                            .offset(y: 120)
                        
                        HStack(spacing: 9) {
                            ForEach(media.indices, id: \.self){ index in
                                Circle()
                                    .fill(Color(red:0.9, green:0.9, blue:0.9).opacity(currentIndex == index ? 1 : 0.3))
                                    .frame(width: 5, height: 5)
                                    .animation(.spring(), value: currentIndex == index)
                            }
                        }
                        .offset(y: 120)
                    }
                    .allowsHitTesting(false)
                }
            }
            

        }
            
    }
}

struct RecordImage_Previews: PreviewProvider {
    
    static var media: [String] = ["https://images.collections.yale.edu/iiif/2/ypm:7c1403f0-eae7-4f39-ad20-34f9857e6d16/full/!1920,1920/0/default.jpg", "https://images.collections.yale.edu/iiif/2/ypm:5576300f-38dd-488c-a5c1-f5676aa53956/full/!1920,1920/0/default.jpg", "https://images.collections.yale.edu/iiif/2/ypm:fbc8b5e8-a0de-4d47-bb5f-caf85dc4f373/full/full/0/default.jpg", "https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=b6d6ed3d-e36b-4b1d-a951-515183455a8e", "https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=7557297a-173e-45c3-a2aa-819dd6189984", "https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=12e4c2ad-abcb-4052-80d8-ab266f2d6d35", "https://images.ala.org.au/image/proxyImageThumbnailLarge?imageId=9485d959-fbcf-4b38-853b-c6aa848b7116"]
    
    static var previews: some View {
        ImageCarousel(media: media)
    }
}
