//
//  SectionTitle.swift
//  MindValley
//
//  Created by Yura on 7/2/22.
//

import Foundation
import SwiftUI

struct SectionTitle: ViewModifier {
    let fontSize: CGFloat
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .font(Font.custom("Roboto-Regular", size: fontSize))
    }
}
