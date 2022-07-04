//
//  ImageView.swift
//  MindValley
//
//  Created by Yura on 7/4/22.
//

import SwiftUI

struct ImageView: View {
    @EnvironmentObject var dataManager: DataManager
    
    let imageURL: String
    
    var body: some View {
        if let imageData = dataManager.loadImage(path: imageURL) {
            if let image = UIImage(data: imageData) {
                Image(uiImage: image)
            }
        } else {
            AsyncImage(
                url: URL(string: imageURL),
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
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageURL: "https://assets.mindvalley.com/api/v1/assets/cb8c79d9-af35-4727-9c4c-6e9eee5af1c3.jpg?transform=w_1080")
    }
}
