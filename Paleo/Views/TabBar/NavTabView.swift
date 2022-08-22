//
//  NavTabView.swift
//  Paleo
//
//  Created by Joseph Zhu on 29/6/2022.
//

import SwiftUI

struct NavTabView: View {
    @EnvironmentObject private var viewModel: MapViewModel
    @EnvironmentObject private var imageModel: ImageModel
    
    @StateObject var redFilterModel = RedFilterModel()
    @State var currentTab: TabBarItem = .map
    @State private var iconColor: Color = .init(red:0.8, green:0.8, blue:0.8)
    let inactiveColor: Color = .init(red:0.3, green:0.3, blue:0.3)
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) { [weak viewModel, weak imageModel] in
            if let viewModel = viewModel, let imageModel = imageModel {
                
                TabView(selection: $currentTab) {
                    SearchView(currentTab: $currentTab)
                        .environmentObject(redFilterModel)
                        .tag(.search as TabBarItem)
                          
                    MapView()
                        .ignoresSafeArea(.all, edges: .all)
                        .tag(.map as TabBarItem)
                    
                    FilterView()
                        .background(Color(red:0.05, green:0.05, blue:0.05))
                        .ignoresSafeArea(.all, edges: .all)
                        .tag(.filter as TabBarItem)
                }
                
                HStack(spacing: 0) {
                    ForEach(TabBarItem.allCases, id: \.self) { tab in
                        Button(action: { [weak viewModel] in
                            if tab == .map && tab == currentTab {
                                guard let viewModel = viewModel else {return}
                                viewModel.requestAllowOnceLocationPermission()
                            } else {
                                withAnimation(Animation.easeOut(duration: 0.05)) {
                                    currentTab = tab
                                            
                                    iconColor = Color.white
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
                                        withAnimation(.easeIn) {
                                            iconColor = Color(red:0.8, green:0.8, blue:0.8)
                                        }
                                    }
                                }
                            }
                        }, label: {
                            ZStack() {
                                if tab == .map {
                                    Circle()
                                        .fill(.ultraThickMaterial)
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .scaleEffect(currentTab == tab ? 1.5 : 1.0)
                                        .opacity(currentTab == tab ? 1.0 : 0.0)
                                    
                                    if currentTab == tab {
                                        Image(systemName: "scope")
                                            .resizable()
                                            .renderingMode(.template)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25, height: 25)
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(currentTab == tab ? iconColor : inactiveColor)
                                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 3)
                                            .scaleEffect(currentTab == tab ? 1.5 : 1.0)
                                            .opacity(currentTab == tab ? 1.0 : 0.0)
                                            .transition(.scale)
                                    }
                                    
                                    Image(systemName: tab.icon)
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(currentTab == tab ? iconColor : inactiveColor)
                                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 3)
                                        .scaleEffect(currentTab == tab ? 1.5 : 1.0)
                                        .opacity(currentTab == tab ? 0.0 : 1.0)
                                } else {
                                    if tab == .filter {
                                        Image(systemName: tab.icon)
                                            .resizable()
                                            .renderingMode(.template)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.red)
                                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 3)
                                            .scaleEffect(redFilterModel.redAnimation + 1.0)
                                            .opacity(redFilterModel.redAnimation)
                                    }
                                    
                                    Image(systemName: tab.icon)
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(currentTab == tab ? iconColor : inactiveColor)
                                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 3)
                                        .scaleEffect(currentTab == tab ? 1.5 : 1.0)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        })
                        .disabled(currentTab == tab && tab != .map)
                        
                        if tab != TabBarItem.allCases.last {Spacer(minLength: 50)}
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 5)
                .opacity(0.9)
                
                .background(
                    Color(red:0.1, green:0.1, blue:0.1).opacity(0.95)
                        .ignoresSafeArea(edges: .bottom))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 6)
                .padding(.horizontal)
                .frame(maxWidth: 300)
                
                .offset(y: -24)
                .ignoresSafeArea(.all, edges: .all)
                
                if imageModel.isShowImage {
                    ZStack {
                        Color.black
                            
                        imageModel.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .center)
                            .position(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
                            .scaleEffect(imageModel.finalScale)
                            .offset(imageModel.finalOffset)
                    }
                    .ignoresSafeArea(.all, edges: .all)
                    .onTapGesture {
                        imageModel.isShowImage = false
                        DispatchQueue.main.async {
                            imageModel.finalScale = 1.0
                            imageModel.previousScale = 1.0
                            imageModel.finalOffset = .zero
                            imageModel.savedOffset = .zero
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                imageModel.finalOffset.width = imageModel.savedOffset.width + value.translation.width
                                imageModel.finalOffset.height = imageModel.savedOffset.height + value.translation.height
                            }
                            .onEnded { value in
                                imageModel.savedOffset = imageModel.finalOffset
                            }
                            .exclusively(before:
                                MagnificationGesture()
                                    .onChanged { value in
                                        let delta = value / imageModel.previousScale
                                        let nextFinalScale = min(max((imageModel.finalScale * delta), 1.0), 2.0)
                                        let offsetCoeff = (1 + 0.5 * (nextFinalScale - imageModel.finalScale))
                                        
                                        imageModel.finalOffset.width = imageModel.finalOffset.width * offsetCoeff
                                        imageModel.finalOffset.height = imageModel.finalOffset.height * offsetCoeff
                                        
                                        imageModel.previousScale = value
                                        imageModel.finalScale = nextFinalScale
                                    }
                                    .onEnded { value in
                                        imageModel.previousScale = 1.0
                                        if imageModel.finalScale == 1 {
                                            withAnimation(.spring()) {
                                                imageModel.finalOffset = .zero
                                            }
                                            imageModel.savedOffset = .zero
                                        }
                                        imageModel.savedOffset = imageModel.finalOffset
                                    }
                            )
                    )
                }
                
            }
        }
        
    }
}

struct NavTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavTabView()
    }
}
