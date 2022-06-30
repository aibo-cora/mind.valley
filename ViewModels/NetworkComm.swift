//
//  NetworkComm.swift
//  MindValley
//
//  Created by Yura on 6/30/22.
//

import Foundation

final class NetworkComm {
    public enum NetworkErrors: Error {
        case badContents, badURL
    }
    
    public enum NetworkEndpoints: String {
        case episodes = "https://pastebin.com/raw/z5AExTtw"
        case channels = "https://pastebin.com/raw/Xt12uVhM"
        case categories = "https://pastebin.com/raw/A0CgArX3"
    }
    
    public func getNetworkData(endpoint: String) async throws -> String {
        if let url = URL(string: endpoint) {
            do {
                let contents = try String(contentsOf: url)
                
                return contents
            } catch {
                throw NetworkErrors.badContents
            }
        } else {
            throw NetworkErrors.badURL
        }
    }
}
