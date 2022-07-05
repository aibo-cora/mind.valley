//
//  EpisodeData.swift
//  MindValley
//
//  Created by Yura on 6/30/22.
//

import Foundation

struct EpisodesData: Codable {
    let data: MediaList
    
    struct MediaList: Codable {
        let media: [Media]
    }
}

extension EpisodesData: NetworkResponse {
    func write(to url: URL?) throws {
        if let url = url {
            try (JSONEncoder().encode(self)).write(to: url)
        }
    }
}
