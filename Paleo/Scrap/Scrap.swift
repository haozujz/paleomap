//
//  scrap.swift
//  Paleo
//
//  Created by Joseph Zhu on 30/7/2022.
//

//clear the cache, of loading views as image, or reset simulator
// product -> clean build folder


// Debgugging
//let _ = Self._printChanges()
//
//extension ShapeStyle where Self == Color {
//    static var random: Color {
//        Color(
//            red: .random(in: 0...1),
//            green: .random(in: 0...1),
//            blue: .random(in: 0...1)
//        )
//    }
//}

//extension View {
//    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
//        if condition {
//            transform(self)
//        } else {
//            self
//        }
//    }
//}

//euclidean dist but skip sqrt
//    func geoDistance(loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) -> Double {
//        let xD = loc1.latitude - loc2.latitude
//        let yD = loc1.longitude - loc2.longitude
//        return pow(xD, 2) + pow(yD, 2)
//    }
