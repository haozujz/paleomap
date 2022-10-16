//
//  RecordCarousel.swift
//  Paleo
//
//  Created by Joseph Zhu on 12/6/2022.
//

import SwiftUI

struct RecordCarousel: View {
    @EnvironmentObject private var selectModel: RecordSelectModel
    
    @State private var currentIndex: Int = 0
    @State private var isShowLargeImage: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) { [weak selectModel] in
            if let selectModel = selectModel {
                
                HStack(spacing: 9) {
                    ForEach(selectModel.recordsNearby?.indices ?? 0..<0, id: \.self){ index in
                        Circle()
                            .fill(currentIndex == index ? .white : .gray).opacity(currentIndex == index ? 0.9 : 0.8)
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentIndex == index ? 1.3 : 1)
                            .animation(.spring(), value: currentIndex == index)
                    }
                }
                .offset(y: -57)
                .onChange(of: selectModel.recordsNearby) { _ in
                    currentIndex = 0
                }
                
                CarouselHV(currentIndex: $currentIndex, items: selectModel.recordsNearby ?? []) { record  in
                    RecordCard(record: record)
                        .animation(.easeInOut(duration: 0.2), value: selectModel.isDetailedMode)
                }
                .offset(y: -40)
                
            }
        }
        .frame(height: 170)
    }
}


struct RecordCarousel_Previews: PreviewProvider {
    static var previews: some View {
        RecordCarousel()
            .environmentObject(RecordSelectModel())
    }
}

