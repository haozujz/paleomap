//
//  PhylumTogglePreferenceKey.swift
//  Paleo
//
//  Created by Joseph Zhu on 18/7/2022.
//

// bug: same preference key on multiple children views with preference modifer at child scope results in only the last child being able to modify preference key data
import Foundation
import SwiftUI

struct PhylumTogglePreferenceKey: PreferenceKey {
    static var defaultValue: PhylumTogglePreferenceKeyData? = nil
    
    static func reduce(value: inout PhylumTogglePreferenceKeyData?, nextValue: () -> PhylumTogglePreferenceKeyData?) {
        value = nextValue()
    }
}

struct PhylumTogglePreferenceKeyData: Equatable {
    let phylum: Phylum
    let isActive: Bool
}

//    .onPreferenceChange(PhylumTogglePreferenceKey.self) { value in
//        if let data = value {
//            print(data)
//            exclusionDict[data.phylum] = data.isActive
//        }
//    }

//    .preference(key: PhylumTogglePreferenceKey.self, value: PhylumTogglePreferenceKeyData(phylum: phylum, isActive: true))

//    .onDisappear {
//        var x: [Phylum] = []
//        exclusionDict.keys.forEach { phylum in
//            let b: Bool? = exclusionDict[phylum]
//            if let isActive = b {
//                if !isActive {x.append(phylum)}
//            }
//        }
//        modelData.exclusionList = x
//        print(modelData.exclusionList)
//    }


