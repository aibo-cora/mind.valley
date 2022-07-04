//
//  ContentView.swift
//  Shared
//
//  Created by Yura on 6/30/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    
    @ViewBuilder var body: some View {
        switch dataManager.sessionStatus {
        case .downloaded:
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        /// New Episodes
                        MediaView(media: dataManager.episodes, sectionTitle: "New Episodes")
                        /// Channels
                        ForEach(dataManager.channels, id: \.title) { channel in
                            if channel.series.count > 0 {
                                MediaView(media: channel.series, sectionTitle: channel.title)
                            } else {
                                MediaView(media: channel.latestMedia, sectionTitle: channel.title)
                            }
                        }
                        /// Categories
                        BrowseCategoriesView(categories: dataManager.categories)
                    }
                    .environmentObject(dataManager)
                }
                .navigationTitle("Channels")
            }
            .navigationViewStyle(.stack)
        default:
            ProgressView()
                .task {
                    await dataManager.getSectionData()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (3rd generation)"))
                .previewDisplayName("iPad Pro (11-inch)")
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
                .previewDisplayName("iPhone 13 Pro Max")
                .preferredColorScheme(.dark)
        }
        
    }
}
