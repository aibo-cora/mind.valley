//
//  SectionTitle.swift
//  MindValley
//
//  Created by Yura on 7/2/22.
//

import Foundation
import SwiftUI

struct SectionTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(hex: "95989D"))
            .font(.system(size: 20, weight: .heavy, design: .default))
            .padding(.leading, 22)
            .padding(.top, 30)
    }
}
