//
//  Channels.swift
//  MindValley
//
//  Created by Yura on 6/30/22.
//

import Foundation

struct ChannelsData: Decodable {
    let data: ChannelList
    
    struct ChannelList: Decodable {
        let channels: [Channel]
    }
    
    struct Channel: Decodable {
        let title: String
        let series: [Series]
        let mediaCount: Int
        let latestMedia: [Media]
        let id: String?
        let iconAsset: IconAsset?
        let coverAsset: CoverAsset
        
        struct Series: Decodable, MediaContent, Hashable {
            let id = UUID()
            
            static func == (lhs: ChannelsData.Channel.Series, rhs: ChannelsData.Channel.Series) -> Bool {
                lhs.id == rhs.id
            }
            
            func hash(into hasher: inout Hasher) {
                hasher.combine(id)
            }
            
            var channel: Media.Channel?
            
            let title: String
            let coverAsset: CoverAsset
        }
        
        struct IconAsset: Decodable {
            let thumbnailUrl: String?
        }
    }
}

extension ChannelsData: NetworkResponse {}
