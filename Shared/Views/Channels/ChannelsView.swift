//
//  ContentView.swift
//  Shared
//
//  Created by Yura on 6/30/22.
//

import SwiftUI

struct ChannelsView: View {
    @StateObject private var dataManager = ChannelsViewModel()
    
    @ViewBuilder var body: some View {
        switch dataManager.sessionStatus {
        case .downloaded:
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        /// New Episodes
                        MediaView(media: dataManager.episodes, sectionTitle: "New Episodes", channel: nil)
                        /// Channels
                        ForEach(dataManager.channels, id: \.title) { channel in
                            if channel.series.count > 0 {
                                MediaView(media: channel.series, sectionTitle: channel.title, channel: channel)
                            } else {
                                MediaView(media: channel.latestMedia, sectionTitle: channel.title, channel: channel)
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

struct ChannelsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChannelsView()
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (3rd generation)"))
                .previewDisplayName("iPad Pro (11-inch)")
            ChannelsView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
                .previewDisplayName("iPhone 13 Pro Max")
                .preferredColorScheme(.dark)
        }
        
    }
}
