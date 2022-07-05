//
//  EpisodeView.swift
//  MindValley
//
//  Created by Yura on 7/2/22.
//

import SwiftUI

struct MediaView<T>: View where T: MediaContent {
    @Environment(\.colorScheme) var colorScheme
    
    var media: [T]
    let sectionTitle: String
    
    @State private var pressed = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                let isNewEpisodesSection = sectionTitle == "New Episodes"
                
                if !isNewEpisodesSection {
                    Image(systemName: "book")
                        .frame(width: 50, height: 50)
                }
                
                VStack(alignment: .leading) {
                    Text(sectionTitle)
                        .modifier(SectionTitle(fontSize: 20, color: isNewEpisodesSection ? Color(hex: "95989D") : (colorScheme == .dark ? .white : .black)))
                    if !(isNewEpisodesSection) {
                        Text("\(media.count)" + " " + (media is [Media] ? "episodes" : "series"))
                            .modifier(SectionTitle(fontSize: 16, color: Color(hex: "95989D")))
                    }
                }
            }
            ScrollViewReader { scrollview in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack() {
                        ForEach(Array(media.enumerated()), id: \.element) { index, media in
                            if index < 6 {
                                VStack() {
                                    ImageView(imageURL: media.coverAsset.url, imageSize: CGSize(width: 175, height: 228))
                                    
                                    VStack {
                                        Text(media.title)
                                            .frame(width: 175, height: 100)
                                        Text(media.channel?.title.uppercased() ?? "")
                                            .foregroundColor((Color(hex: "95989D")))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Divider()
                .padding()
        }
        .padding()
    }
}

struct EpisodeView_Previews: PreviewProvider {
    static var previews: some View {
        MediaView(media: [Media(type: "", title: "Raising Kids With Healthy Beliefs", coverAsset: CoverAsset(url: "https://assets.mindvalley.com/api/v1/assets/cb8c79d9-af35-4727-9c4c-6e9eee5af1c3.jpg?transform=w_1080"), channel: Media.Channel.init(title: "Little Humans"))], sectionTitle: "New Episodes")
    }
}
