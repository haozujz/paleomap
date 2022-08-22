//
//  GridStack.swift
//  Paleo
//
//  Created by Joseph Zhu on 16/7/2022.
//

import Foundation
import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let cols: Int
    let rowSpacing: CGFloat
    let colSpacing: CGFloat
    let content: (Int, Int) -> Content
    
    init(rows: Int, cols: Int, rowSpacing: CGFloat, colSpacing: CGFloat, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.cols = cols
        self.rowSpacing = rowSpacing
        self.colSpacing = colSpacing
        self.content = content
    }

    var body: some View {
        VStack(spacing: rowSpacing) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: colSpacing) {
                    ForEach(0 ..< cols, id: \.self) { col in
                        content(row, col)
                    }
                }
            }
        }
    }

}

