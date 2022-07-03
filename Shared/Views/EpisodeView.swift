//
//  EpisodeView.swift
//  MindValley
//
//  Created by Yura on 7/2/22.
//

import SwiftUI

struct EpisodeView: View {
    let episode: Media
    
    @State private var pressed = false
    var body: some View {
        VStack {
            AsyncImage(
                url: URL(string: episode.coverAsset.url),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 175, height: 228, alignment: .center)
                        .cornerRadius(10)
                },
                placeholder: {
                    ProgressView()
                }
            )
            .padding()
            
            VStack {
                Text(episode.title)
                    .multilineTextAlignment(.leading)
                    .frame(width: 175, alignment: .leading)
                    .padding(.bottom)
                Text(episode.channel?.title.uppercased() ?? "")
            }
        }
        .onAppear {
            print(episode.coverAsset.url)
        }
    }
}

struct EpisodeView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeView(episode: Media(type: "", title: "Raising Kids With Healthy Beliefs", coverAsset: CoverAsset(url: "https://assets.mindvalley.com/api/v1/assets/cb8c79d9-af35-4727-9c4c-6e9eee5af1c3.jpg?transform=w_1080"), channel: Media.Channel.init(title: "Little Humans")))
    }
}
