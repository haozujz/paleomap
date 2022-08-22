//
//  Carousel.swift
//  Paleo
//
//  Created by Joseph Zhu on 10/6/2022.
//

import Foundation
import SwiftUI

struct CarouselHV<Content: View, T: Identifiable>: View {
    @EnvironmentObject private var selectModel: RecordSelectModel
    @Binding var currentIndex: Int
    private var content: (T) -> Content
    private var list: [T]
    
    private let spacing: CGFloat
    private let trailingSpace: CGFloat
    
    //trailingSpace eg. 65 for 390 width screen & 320 width items
    init(spacing: CGFloat = 20, trailingSpace: CGFloat = UIScreen.main.bounds.size.width - 325, currentIndex: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T)->Content){
        self.list = items
        self._currentIndex = currentIndex
        self.content = content
        self.spacing = spacing
        self.trailingSpace = trailingSpace
    }
    
    @GestureState private var offset: CGPoint = .init(x:0, y:0)
    @State private var index: Int = 0
    
    @State private var direction: DragDirection = .none
    enum DragDirection {
        case none, horizontal, vertical
    }
    
    @State private var refreshIconSize: CGFloat = 0.0
    @State private var refreshIconRotation: CGFloat = 0.0
    
    var body: some View {
        ZStack { [weak selectModel] in
            if let selectModel = selectModel {
                
                GeometryReader { proxy in
                    let width = proxy.size.width - (trailingSpace - spacing)
                    let adjustmentWidth = (trailingSpace / 2) - spacing
                    
                    HStack(spacing: spacing) {
                        ForEach(list){item in
                            content(item)
                                .frame(width: proxy.size.width - trailingSpace, height: 100)
                        }
                    }
                    .padding(.horizontal,spacing)
                    .offset(x: (CGFloat(currentIndex) * -width) + adjustmentWidth + offset.x, y: offset.y)
                    .gesture(
                        DragGesture()
                            .updating($offset, body: { value, out, _ in
                                let x = value.translation.width
                                let y = value.translation.height
                                
                                switch direction {
                                case .horizontal:
                                    out.x = x
                                case .vertical:
                                    if !selectModel.isDetailedMode && y < 0 && y > -500 {out.y = y}
                                    else if selectModel.isDetailedMode && y > 0 && y < 500 {out.y = y}
                                case .none:
                                    return
                                }
                            })
                            .onChanged { value in
                                let x = value.translation.width
                                let y = value.translation.height
                                
                                switch direction {
                                case .horizontal:
                                    let xOffset = max(min(value.predictedEndTranslation.width, width/2), -width/2)
                                    let progress = -xOffset / width
                                    let roundIndex = progress.rounded()
                                    index = max(min(currentIndex + Int(roundIndex), list.count), 0)
                                    refreshIconSize = currentIndex == list.count - 1 ? min(max(((CGFloat(currentIndex) + x) * -1/(width/2)), 0), 1.01) : 0
                                    refreshIconRotation = refreshIconSize * 360
                                case .vertical:
                                    return
                                case .none:
                                    if x > 5 || x < -5 || y < -5 || y > 5  {
                                        if abs(x) >= abs(y) {direction = .horizontal}
                                        else {direction = .vertical}
                                    }
                                }
                            }
                            .onEnded { value in
                                switch direction {
                                case .horizontal:
                                    if index == list.count {
                                        refreshIconSize = 1.5
                                        withAnimation(.spring()) { refreshIconRotation += 480 }
                                        selectModel.updateRecordsNearby()
                                        index = 0
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            refreshIconSize = 0
                                        }
                                    } else {
                                        refreshIconSize = 0
                                    }
                                    currentIndex = index
                                case .vertical:
                                    if !selectModel.isDetailedMode && value.predictedEndTranslation.height < -100 {selectModel.isDetailedMode = true}
                                    else if selectModel.isDetailedMode && value.predictedEndTranslation.height > 100 {selectModel.isDetailedMode = false}
                                case .none:
                                    return
                                }
                                direction = .none
                            }
                    )
                }
                .animation(.easeInOut, value: offset == CGPoint(x:0,y:0))
                .offset(y: selectModel.isDetailedMode ? -400 : 0)
                
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .symbolRenderingMode(.monochrome)
                    .font(.system(size: 80, weight: .heavy))
                    .foregroundStyle(refreshIconSize > 1 ? Color(red:0.8, green:0.8, blue:0.8) : Color(red:0.65, green:0.65, blue:0.65))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .rotationEffect(.degrees(refreshIconRotation + 90.0), anchor: .center)
                    .background(
                        ZStack {
                            Circle()
                                .fill(Color(red:0.8, green:0.8, blue:0.8))
                            Circle()
                                .fill(refreshIconSize > 1 ? Material.thickMaterial : Material.thinMaterial)
                        }
                        .shadow(color: .black.opacity(0.88), radius: 7, y: 5)
                        .frame(width: 80, height: 80)
                    )
                    .opacity(refreshIconSize)
                    .scaleEffect(refreshIconSize)
                    .offset(y: selectModel.isDetailedMode ? -270 : -70)
                    .animation(.spring(response: 0.1), value: refreshIconSize)
                    .allowsHitTesting(false)
                    .frame(width: UIScreen.main.bounds.size.width)
                
            }
        }
    }
}
