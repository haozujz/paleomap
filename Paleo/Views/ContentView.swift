//
//  ContentView.swift
//  Paleo
//
//  Created by Joseph Zhu on 23/5/2022.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavTabView()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
