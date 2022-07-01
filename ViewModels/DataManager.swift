//
//  DataManager.swift
//  MindValley
//
//  Created by Yura on 6/30/22.
//

import Foundation
import Combine

final class DataManager: ObservableObject {
    var subscriptions = [AnyCancellable]()
    
    @Published var episodes = [Media]()
    @Published var channels = [ChannelsData.Channel]()
    @Published var categories = [CategoriesData.Category]()
    
    public enum SessionStatus: Error {
        case downloaded, downloading, networkError, unknown
    }
    @Published var sessionStatus: SessionStatus = SessionStatus.unknown {
        willSet {
            print(newValue)
        }
    }
    
    let network = NetworkComm()
    
    public func getSectionData() async {
        do {
            updateStatus(status: .downloading)
            
            try network.getNetworkData(endpoint: NetworkComm.NetworkEndpoints.episodes.rawValue, using: EpisodesData.self)
                .receive(on: DispatchQueue.main)
                .map(\.data)
                .sink(receiveCompletion: { print($0) }, receiveValue: { [unowned self] mediaList in
                    episodes = mediaList.media
                    
                    print(episodes)
                })
                .store(in: &subscriptions)
            try network.getNetworkData(endpoint: NetworkComm.NetworkEndpoints.channels.rawValue, using: ChannelsData.self)
                .receive(on: DispatchQueue.main)
                .map(\.data)
                .sink(receiveCompletion: { print($0) }, receiveValue: { [unowned self] channelList in
                    channels = channelList.channels
                    
                    // print(episodes)
                })
                .store(in: &subscriptions)
            try network.getNetworkData(endpoint: NetworkComm.NetworkEndpoints.categories.rawValue, using: CategoriesData.self)
                .receive(on: DispatchQueue.main)
                .map(\.data)
                .sink(receiveCompletion: { print($0) }, receiveValue: { [unowned self] categoryList in
                    categories = categoryList.categories
                    
                    // print(episodes)
                })
                .store(in: &subscriptions)
            
            updateStatus(status: .downloaded)
        } catch NetworkComm.NetworkErrors.badURL {
            updateStatus(status: .networkError)
        } catch NetworkComm.NetworkErrors.badContents {
            updateStatus(status: .networkError)
        } catch {
            updateStatus(status: .unknown)
        }
    }
    
    func updateStatus(status: SessionStatus) {
        DispatchQueue.main.async { [unowned self] in
            sessionStatus = status
        }
    }
}
