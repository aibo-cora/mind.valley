//
//  Shared.swift
//  MindValley
//
//  Created by Yura on 6/30/22.
//

import Foundation

struct Media: Codable, MediaContent {
    static func == (lhs: Media, rhs: Media) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id = UUID()
    
    let type: String
    let title: String
    let coverAsset: CoverAsset
    let channel: Channel?
    
    struct Channel: Codable {
        let title: String
    }
}

struct CoverAsset: Codable {
    let url: String
}

protocol NetworkResponse {
    associatedtype R
    var data: R { get }
    
    func write(to url: URL?) throws
}

protocol MediaContent: Hashable {
    var id: UUID { get }
    var title: String { get }
    var coverAsset: CoverAsset { get }
    
    var channel: Media.Channel? { get }
}
