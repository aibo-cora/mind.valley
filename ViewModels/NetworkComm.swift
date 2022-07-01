//
//  NetworkComm.swift
//  MindValley
//
//  Created by Yura on 6/30/22.
//

import Foundation
import Combine

final class NetworkComm {
    var subscriptions = [AnyCancellable]()
    
    public enum NetworkErrors: Error {
        case badContents, badURL, decodingFailed
        case sessionFailed(error: Error)
        case other(_ error: Error)
    }
    
    public enum NetworkEndpoints: String, CaseIterable {
        case episodes = "https://pastebin.com/raw/z5AExTtw"
        case channels = "https://pastebin.com/raw/Xt12uVhM"
        case categories = "https://pastebin.com/raw/A0CgArX3"
    }
    
    public func getNetworkData<T: Decodable>(endpoint: String, using type: T.Type) throws -> AnyPublisher<T, NetworkErrors> where T: NetworkResponse {
        if let url = URL(string: endpoint) {
            return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap() { response -> Data in
                    guard let httpResponse = response.response as? HTTPURLResponse,
                        httpResponse.statusCode == 200 else { throw URLError(.badServerResponse) }
                    
                    print(httpResponse.statusCode)
                    
                    return response.data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError({ error -> NetworkErrors in
                    print(error.localizedDescription)
                    switch error {
                    case is Swift.DecodingError:
                        return .decodingFailed
                    case let urlError as URLError:
                        return .sessionFailed(error: urlError)
                    default:
                        return .other(error)
                    }
                })
                .eraseToAnyPublisher()
        } else {
            throw NetworkErrors.badURL
        }
    }
}
