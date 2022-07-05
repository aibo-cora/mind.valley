//
//  EpisodeView.swift
//  MindValley
//
//  Created by Yura on 7/2/22.
//

import SwiftUI

struct MediaView<T>: View where T: MediaContent {
    @Environment(\.colorScheme) var colorScheme
    
    let media: [T]
    let sectionTitle: String
    var channel: ChannelsData.Channel? = nil
    
    @State private var pressed = false
    var body: some View {
        VStack(alignment: .leading) {
            SectionTitleView(colorScheme: colorScheme, media: media, sectionTitle: sectionTitle, channel: channel)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack() {
                    ForEach(Array(media.enumerated()), id: \.element) { index, media in
                        /// `6` items per row
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
            Divider()
                .padding()
        }
        .padding()
    }
}

struct SectionTitleView<T>: View where T: MediaContent {
    let colorScheme: ColorScheme
    let media: [T]
    let sectionTitle: String
    var channel: ChannelsData.Channel? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            if let channel = channel {
                /// thumbnail URLs return `404` or are `null`
                ImageView(imageURL: channel.iconAsset?.thumbnailUrl, imageSize: CGSize(width: 50, height: 50))
            }
            
            let isNewEpisodesSection = sectionTitle == "New Episodes"
            VStack(alignment: .leading) {
                Text(sectionTitle)
                    .modifier(SectionTitle(fontSize: 20, color: isNewEpisodesSection ? Color(hex: "95989D") : (colorScheme == .dark ? .white : .black)))
                if !(isNewEpisodesSection) {
                    Text("\(media.count)" + " " + (media is [Media] ? "episodes" : "series"))
                        .foregroundColor(Color(hex: "95989D"))
                        .font(Font.custom("Roboto-Regular", size: 16))
                }
            }
        }
    }
}

struct EpisodeView_Previews: PreviewProvider {
    static var previews: some View {
        MediaView(media: [Media(type: "", title: "Raising Kids With Healthy Beliefs", coverAsset: CoverAsset(url: "https://assets.mindvalley.com/api/v1/assets/cb8c79d9-af35-4727-9c4c-6e9eee5af1c3.jpg?transform=w_1080"), channel: Media.Channel.init(title: "Little Humans"))], sectionTitle: "New Episodes")
    }
}
