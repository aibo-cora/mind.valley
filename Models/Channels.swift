//
//  Channels.swift
//  MindValley
//
//  Created by Yura on 6/30/22.
//

import Foundation

struct ChannelsData: Decodable {
    var data: ChannelList
    
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
        
        struct Series: Decodable {
            
        }
        
        struct IconAsset: Decodable {
            let thumbnailUrl: String?
        }
    }
}

extension ChannelsData: NetworkResponse {}
