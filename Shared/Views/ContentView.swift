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
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    switch dataManager.sessionStatus {
                    case .downloaded:
                        VStack(alignment: .leading) {
                            MediaView(media: dataManager.episodes, sectionTitle: "New Episodes")
                            Divider()
                                .padding()
                            ForEach(dataManager.channels, id: \.title) { channel in
                                if channel.series.count > 0 {
                                    MediaView(media: channel.series, sectionTitle: channel.title)
                                } else {
                                    MediaView(media: channel.latestMedia, sectionTitle: channel.title)
                                }
                            }
                            Divider()
                                .padding()
                            VStack(alignment: .leading) {
                                Text("Browse by categories")
                                    .modifier(SectionTitle())
                                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2)) {
                                    ForEach(dataManager.categories, id: \.name) { category in
                                        Capsule(style: .circular)
                                            .foregroundColor((Color(hex: "95989D")))
                                            .frame(width: 175, height: 75)
                                            .overlay {
                                                Text(category.name)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            .padding(10)
                                    }
                                }
                            }
                            
                        }
                    default:
                        ProgressView()
                            .task {
                                await dataManager.getSectionData()
                            }
                    }
                }
                .navigationTitle("Channels")
            }
            
        }
        .navigationViewStyle(.stack)
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
