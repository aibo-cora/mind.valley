//
//  EpisodeData.swift
//  MindValley
//
//  Created by Yura on 6/30/22.
//

import Foundation

struct EpisodesData: Decodable {
    var data: MediaList
    
    struct MediaList: Decodable {
        let media: [Media]
    }
}

extension EpisodesData: NetworkResponse {}
