//
//  ImageModel.swift
//  Paleo
//
//  Created by Joseph Zhu on 13/7/2022.
//

import Foundation
import SwiftUI

final class ImageModel: ObservableObject {
    @Published var image: Image = Image("")
    @Published var isShowImage: Bool = false
    @Published var finalScale: CGFloat = 1.0
    var previousScale: CGFloat = 1.0
    @Published var finalOffset: CGSize = .zero
    var savedOffset: CGSize = .zero
}
