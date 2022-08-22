//
//  ContentView.swift
//  Paleo
//
//  Created by Joseph Zhu on 15/4/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        MapView()
            .onAppear {
                modelData.getRecords()
        }

        
//        ScrollView {
//            Text("here")
//            ForEach(modelData.records, id: \.self.uuid) { record in
//                HStack(alignment: .top) {
//                    Text("\(record.indexTerms.locality)")
//                }
//            }
//        }
//        .onAppear {
//            //modelData.getRecords()
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
