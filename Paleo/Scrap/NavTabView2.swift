//
//  NavTabView.swift
//  Paleo
//
//  Created by Joseph Zhu on 26/6/2022.
//

// morphing tab bar shape
import SwiftUI

struct NavTabView2: View {
    @State var currentTab: String = "map"
    let tabs: [String] = ["search", "map", "filter"]
    
    @State private var inset: CGFloat = 70.0
    let maxInset: CGFloat = 70.0
    
    @State private var imageColor: Color = .init(red:0.1, green:0.1, blue:0.1)
    
//    init() {
//        UITabBar.appearance().isHidden = true
//    }
    
    func getImage(tab: String) -> String {
        if tab == "search" {return "magnifyingglass"}
        else if tab == "map" {return "map"}
        else {return "line.3.horizontal"}
    }
    
//    func getSafeAreaBottom()->CGFloat{
//        let keyWindow = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive})
//            .map({$0 as? UIWindowScene})
//            .compactMap({$0})
//            .first?.windows
//            .filter({$0.isKeyWindow}).first
//        return keyWindow?.safeAreaInsets.bottom ?? 0
//    }
    
    struct IndentShape: Shape {
        var inset: CGFloat
        var animatableData: CGFloat {
            get { inset }
            set { inset = newValue }
        }
        
        func path(in rect: CGRect) -> Path {
            return Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: rect.width, y: 0))
                path.addLine(to: CGPoint(x: rect.width, y: rect.height))
                path.addLine(to: CGPoint(x: 0, y: rect.height))
                
                let center = rect.width/2
                
                path.move(to: CGPoint(x: center - 100, y: 0))
                
                let to1 = CGPoint(x: center, y: inset)
                let control1 = CGPoint(x: center - 70, y: 0)
                let control2 = CGPoint(x: center - 70, y: inset)
                
                let to2 = CGPoint(x: center + 100, y: 0)
                let control3 = CGPoint(x: center + 70, y: inset)
                let control4 = CGPoint(x: center + 70, y: 0)
                
                path.addCurve(to: to1, control1: control1, control2: control2)
                path.addCurve(to: to2, control1: control3, control2: control4)
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $currentTab) {
                Color.red
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("search" as String)
                      
                MapView()
                    .preferredColorScheme(.dark)
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("map" as String)
                
                Color.green
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("filter" as String)
            }
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { tab in
                    Button(action: {
                        withAnimation(Animation.easeOut(duration: 0.07)) {
                            currentTab = tab
                            if currentTab == "map" {inset = maxInset}
                            else {inset = 0}
                                    
                            imageColor = Color.init(red:0.3, green:0.3, blue:0.3)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                                withAnimation(.easeIn) {
                                    imageColor = .gray
                                }
                            }
                        }
                    }, label: {
                        ZStack() {
                            Image(systemName: getImage(tab: tab))
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(currentTab == tab ? imageColor : Color.init(red:0.1, green:0.1, blue:0.1))
                                .scaleEffect(currentTab == tab ? 1.8 : 1.0)
                            
                            Text(tab == "map" ? "" : tab.capitalized)
                                .font(.system(size: 18, weight: .heavy)).foregroundColor(Color.init(red:0.1, green:0.1, blue:0.1))
                                .opacity(currentTab == tab ? 1.0 : 0.0)
                                .transaction { transation in
                                    transation.animation = nil
                                }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    })
                    .disabled(currentTab == tab)
                    
                    if tab != tabs.last {Spacer(minLength: 50)}
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 10)
            //.padding(.bottom, getSafeAreaBottom())
            // Color.init(red:0.9, green:0.9, blue:0.9
            .background(Color.init(red:0.9, green:0.9, blue:0.9).clipShape(IndentShape(inset: inset)))
            .animation(Animation.easeOut(duration: 0.07), value: inset)
            .opacity(0.9)
            .padding(.bottom, 18)
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .safeAreaInset(edge: .bottom, alignment: .trailing, spacing: 0) {
            Color.clear
                .background(Color.black)
                .offset(y: 15)
                .frame(height: 0)
        }
    }
}

//for specific rounded corners
//
//.cornerRadius(15.0, corners: [.topLeft, .bottomLeft])
//
//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape(RoundedCorner(radius: radius, corners: corners))
//    }
//}
//
//struct RoundedCorner: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}

struct NavTabView2_Previews: PreviewProvider {
    static var previews: some View {
        NavTabView2()
    }
}
