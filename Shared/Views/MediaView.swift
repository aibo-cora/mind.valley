//
//  EpisodeView.swift
//  MindValley
//
//  Created by Yura on 7/2/22.
//

import SwiftUI

struct MediaView<T>: View where T: MediaContent {
    var media: [T]
    let sectionTitle: String
    
    @State private var pressed = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                let isNewEpisodesSection = sectionTitle == "New Episodes"
                
                Image(systemName: isNewEpisodesSection ? "" : "book")
                VStack(alignment: .leading) {
                    Text(sectionTitle)
                        .modifier(SectionTitle(fontSize: 20))
                    if !(isNewEpisodesSection) {
                        Text("\(media.count)" + " " + (media is [Media] ? "episodes" : "series"))
                    }
                }
            }
            ScrollViewReader { scrollview in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack() {
                        ForEach(Array(media.enumerated()), id: \.element) { index, media in
                            if index < 6 {
                                VStack() {
                                    AsyncImage(
                                        url: URL(string: media.coverAsset.url),
                                        content: { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 175, height: 228, alignment: .center)
                                                .cornerRadius(10)
                                        },
                                        placeholder: {
                                            ProgressView()
                                                .frame(width: 175, height: 228, alignment: .center)
                                        }
                                    )
                                    .padding([.trailing])
                                    
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
