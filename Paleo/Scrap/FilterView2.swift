//
//  FilterView2.swift
//  Paleo
//
//  Created by Joseph Zhu on 19/7/2022.
//

//
//  FilterView.swift
//  Paleo
//
//  Created by Joseph Zhu on 16/7/2022.
//

//import SwiftUI
//
//struct FilterView: View {
//    @EnvironmentObject var modelData: ModelData
//    @EnvironmentObject private var viewModel: MapViewModel
//    @EnvironmentObject private var selectModel: RecordSelectModel
//
//    @State private var exclusionDict: [Phylum: Bool]
//
//    init() {
//        var x: [Phylum: Bool] = [:]
//        let initialExclusionList: [Phylum] = (UserDefaults.standard.array(forKey: "exclusionListString") as? [String] ?? []).map{ Phylum(rawValue: $0)! }
//
//        Phylum.allCases.forEach { phylum in
//            x[phylum] = !initialExclusionList.contains(phylum)
//        }
//        // exclusionDict does not need to reload view
//        self.exclusionDict = x
//        //self._exclusionDict = State(initialValue: x)
//    }
//
//    func binding(key: Phylum) -> Binding<Bool> {
//        return .init(
//            get: { self.exclusionDict[key, default: true] },
//            set: { self.exclusionDict[key] = $0 }
//        )
//    }
//
//    var body: some View {
//        VStack {
//            Text("Filter")
//                .font(.system(size: 32, weight: .heavy)).foregroundColor(Color(red:0.8, green:0.8, blue:0.8))
//                .offset(x: -130, y: -20)
//
//            ZStack {
//                GridStack(rows: 6, cols: 2, rowSpacing: -100, colSpacing: -120) { row, col in
//                    let phylum: Phylum = Phylum.allCases[row * 2 + col]
//                    PhylumToggle(isActive: binding(key: phylum), phylum: phylum)
//                }
//                .frame(width: 390, height: 600)
//                .offset(y: 0)
//            }
//        }
//        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
//        .onDisappear {
//            var x: [Phylum] = []
//            exclusionDict.keys.forEach { phylum in
//                if let isIncluded = exclusionDict[phylum] {
//                    if !isIncluded {x.append(phylum)}
//                }
//            }
//            if modelData.exclusionList != x {
//                modelData.exclusionList = x
//                let xString = modelData.exclusionList.map{ $0.rawValue }
//                UserDefaults.standard.set(xString, forKey: "exclusionListString")
//
//                if let _ = selectModel.recordsNearby?.first(where: {modelData.exclusionList.contains($0.phylum)}) {
//                    selectModel.updateRecordsSelection(region: viewModel.region, grid: modelData.grid, exclude: modelData.exclusionList, isIgnoreThreshold: true)
//                } else if selectModel.recordsNearby?.count == 0 {
//                    selectModel.updateRecordsSelection(region: viewModel.region, grid: modelData.grid, exclude: modelData.exclusionList, isIgnoreThreshold: true)
//                } else {
//                    selectModel.freezeRecordsNearbyThenUpdate(coord: viewModel.region.center, span: viewModel.region.span, grid: modelData.grid, exclude: modelData.exclusionList, isIgnoreThreshold: true)
//                }
//            }
//        }
//
//    }
//}
//
//struct FilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterView()
//            .background(Color(red:0.05, green:0.05, blue:0.05))
//            .preferredColorScheme(.dark)
//
//        FilterView()
//            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (5th generation)"))
//            .background(Color(red:0.05, green:0.05, blue:0.05))
//            .preferredColorScheme(.dark)
//    }
//}

