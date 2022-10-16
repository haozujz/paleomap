//
//  ImageCarousel.swift
//  Paleo
//
//  Created by Joseph Zhu on 27/7/2022.
//

import Foundation
import SwiftUI

struct CarouselH<Content: View, T: Hashable>: View {
    @EnvironmentObject private var selectModel: RecordSelectModel
    @Binding var currentIndex: Int
    private let content: (T) -> Content
    private let list: [T]
    
    init(currentIndex: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T)->Content){
        self.list = items
        self._currentIndex = currentIndex
        self.content = content
    }
    
    @GestureState private var offset: CGPoint = .init(x:0, y:0)
    @State private var index: Int = 0
    
    var body: some View {
        ZStack { [weak selectModel] in
            if let selectModel = selectModel {
                
                GeometryReader { proxy in
                        let width = proxy.size.width
                        
                        LazyHStack(spacing: 0) {
                            ForEach(list, id: \.self){item in
                                content(item)
                                    .frame(width: proxy.size.width)
                            }
                        }
                        .offset(y: -30)
                        .offset(x: (CGFloat(currentIndex) * -width) + offset.x, y: offset.y)
                        .gesture(
                            DragGesture()
                                .updating($offset, body: { value, out, _ in
                                    if list.count == 1 {return}
                                    let currentOffset = ((CGFloat(currentIndex) * -width) + offset.x)
                                    if currentOffset + value.translation.width > 0 || currentOffset + value.translation.width < (1 - CGFloat(list.count)) * 280  {return}

                                    out.x = value.translation.width
                                })
                                .onChanged { value in
                                    if list.count == 1 {return}
                                    
                                    let xOffset = max(min(value.predictedEndTranslation.width, width/2), -width/2)
                                    let progress = -xOffset / width
                                    let roundIndex = progress.rounded()
                                    
                                    index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                                }
                                .onEnded { value in
                                    if list.count == 1 {return}
                                    
                                    currentIndex = index
                                }
                        )
                }
                .animation(.easeInOut, value: offset == CGPoint(x:0,y:0))
                .onChange(of: selectModel.isDetailedMode) { _ in
                    currentIndex = 0
                }
            }
        }
        
    }
}

