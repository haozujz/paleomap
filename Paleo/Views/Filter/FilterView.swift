//
//  FilterView.swift
//  Paleo
//
//  Created by Joseph Zhu on 16/7/2022.
//

import SwiftUI
import MapKit

struct FilterView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject private var viewModel: MapViewModel
    @EnvironmentObject private var selectModel: RecordSelectModel
    
    @State private var filterDict: [Phylum : Bool]
    
    init() {
        var x: [Phylum : Bool] = [:]
        var dict = UserDefaults.standard.dictionary(forKey: "filterDict") as? [String : Bool] ?? [:]
        
        if dict == [:] {
            var y: [String : Bool] = [:]
            Phylum.allCases.forEach { phylum in
                y[phylum.rawValue] = true
            }
            UserDefaults.standard.set(y, forKey: "filterDict")
            dict = y
        }
        for (k, v) in dict {
            x[Phylum(rawValue: k)!] = v
        }
        self._filterDict = State(initialValue: x)
    }
    
    func binding(key: Phylum) -> Binding<Bool> {
        return .init(
            get: { self.filterDict[key, default: true] },
            set: {
                self.filterDict[key] = $0
                
                var x: [String : Bool] = [:]
                Phylum.allCases.forEach { phylum in
                    x[phylum.rawValue] = self.filterDict[phylum]
                }
                UserDefaults.standard.set(x, forKey: "filterDict")
            }
        )
    }
    
    var body: some View {
        VStack {
            Text("Filter")
                .font(.system(size: 32, weight: .heavy)).foregroundColor(Color(red:0.8, green:0.8, blue:0.8))
                .frame(width: 320, height: 50, alignment: .leading)
                .offset(x: -10, y: UIScreen.main.bounds.size.height < 737 ? -15 : -20)
            
            ZStack {
                GridStack(rows: 6, cols: 2, rowSpacing: -100, colSpacing: -120) { row, col in
                    let phylum: Phylum = Phylum.allCases[row * 2 + col]
                    PhylumToggle(isActive: binding(key: phylum), phylum: phylum)
                }
                .frame(width: 390, height: 600)
            }
            .offset(y: UIScreen.main.bounds.size.height < 737 ? -25 : 0 )
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        .onDisappear { [weak modelData, weak viewModel, weak selectModel] in
            guard let modelData = modelData, let viewModel = viewModel, let selectModel = selectModel else {return}
            
            if modelData.filterDict == filterDict {return}
            guard let recordsNearby = selectModel.recordsNearby else {return}

            modelData.filterDict = filterDict

            if recordsNearby.count == 0 {
                selectModel.updateRecordsSelection(coord: viewModel.region.center, grid: modelData.grid, filter: modelData.filterDict, isIgnoreThreshold: true)
            } else if let _ = recordsNearby.first(where: {!(modelData.filterDict[$0.phylum] ?? true)}) {
                selectModel.updateRecordsSelection(coord: viewModel.region.center, grid: modelData.grid, filter: modelData.filterDict, isIgnoreThreshold: true)
            } else {
                selectModel.freezeRecordsNearbyThenUpdate(coord: viewModel.region.center, grid: modelData.grid, filter: modelData.filterDict, isIgnoreThreshold: true)
            }
            
        }
        
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
            .background(Color(red:0.05, green:0.05, blue:0.05))
            .preferredColorScheme(.dark)
        
        FilterView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (5th generation)"))
            .background(Color(red:0.05, green:0.05, blue:0.05))
            .preferredColorScheme(.dark)
    }
}
