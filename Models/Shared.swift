//
//  Shared.swift
//  MindValley
//
//  Created by Yura on 6/30/22.
//

import Foundation

struct Media: Decodable {
    let id = UUID()
    
    let type: String
    let title: String
    let coverAsset: CoverAsset
    let channel: Channel?
    
    struct Channel: Decodable {
        let title: String
    }
}

struct CoverAsset: Decodable {
    let url: String
}

protocol NetworkResponse {
    associatedtype R
    var data: R { get }
}
