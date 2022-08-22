//
//  DebouncedCoord.swift
//  Paleo
//
//  Created by Joseph Zhu on 5/6/2022.
//

import SwiftUI

struct DebouncedCoord: View {
    @Binding var initialValue: Double
    //@StateObject var debouncedCoordModel = DebouncedCoordModel(initialValue: initialValue.unwrappedValue)

    var body: some View {
        Text("\(initialValue)")
    }
}

class DebouncedCoordModel: ObservableObject {
    //@Binding var initialValue: Double
    
    @Published var currentValue: Double
    @Published var debouncedValue: Double
    
    init(initialValue: Binding<Double>, delay: Double = 0.3) {
        //currentValue = initialValue.wrappedValue
        //self.currentValue = initialValue
        _currentValue = Published(initialValue: initialValue.wrappedValue)
        _debouncedValue = Published(initialValue: initialValue.wrappedValue)
        //self.debouncedValue = initialValue
        $currentValue
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .assign(to: &$debouncedValue)
    }
}

//struct DebouncedCoord_Previews: PreviewProvider {
//    static var previews: some View {
//        DebouncedCoord()
//    }
//}
