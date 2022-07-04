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
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(hex: "95989D"))
            .font(Font.custom("Roboto-Regular", size: fontSize))
    }
}
