//
//  BrowseCategoriesView.swift
//  MindValley (iOS)
//
//  Created by Yura on 7/4/22.
//

import SwiftUI

struct BrowseCategoriesView: View {
    let categories: [CategoriesData.Category]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Browse by categories")
                .modifier(SectionTitle(fontSize: 20, color: Color(hex: "95989D")))
                .padding()
            LazyVGrid(columns: Array(repeating: .init(.flexible()),
                        count: UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2)) {
                ForEach(categories, id: \.name) { category in
                    Capsule(style: .circular)
                        .foregroundColor((Color(hex: "95989D")))
                        .frame(width: 175, height: 75)
                        .overlay {
                            Text(category.name)
                                .multilineTextAlignment(.leading)
                                .font(Font.custom("Roboto-Bold", size: 18))
                        }
                        .padding(10)
                }
            }
        }
    }
}

struct BrowseCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseCategoriesView(categories: [CategoriesData.Category(name: "Healing")])
    }
}
