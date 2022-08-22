//
//  RedFilterModel.swift
//  Paleo
//
//  Created by Joseph Zhu on 22/7/2022.
//

import Foundation
import SwiftUI

final class RedFilterModel: ObservableObject {
    @Published var redAnimation: CGFloat = 0.0
    private var timer: Timer? = nil
    private var animating: Bool = false
    
    func startRedAnimation() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            withAnimation(Animation.easeOut(duration: 0.05)) {
                guard let sSelf = self else {return}
                if sSelf.animating { return }
                else { sSelf.animating = true }
                
                sSelf.redAnimation = 1.0

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeIn) { sSelf.redAnimation = 0.0 }
                    sSelf.animating = false
                }
            }
        }
    }
}
