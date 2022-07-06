//
//  Network.swift
//  Tests iOS
//
//  Created by Yura on 7/5/22.
//

import XCTest
import Combine

class TestNetwork: XCTestCase {
    var subscriptions = [AnyCancellable]()
    
    /// Test network call to retrieve new episodes.
    /// - Throws: <#description#>
    func testEpisodesDataRetrieval() throws {
        let viewModel = ChannelsViewModel()
        let expectation = XCTestExpectation(description: "Publishes 'New Episodes' section data received from server.")

        viewModel
            .$episodes
            .dropFirst()
            .sink(receiveCompletion: { print($0) }) { media in
                XCTAssert(media.count > 0)
                
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        try viewModel.network.getNetworkData(endpoint: NetworkComm.NetworkEndpoints.episodes.rawValue, using: EpisodesData.self)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .sink(receiveCompletion: { print($0) }, receiveValue: { episodes in
                viewModel.episodes = episodes.media
            })
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
    }
    
    /// Test network call to retrieve channels.
    /// - Throws: <#description#>
    func testChannelsDataRetrieval() throws {
        let viewModel = ChannelsViewModel()
        let expectation = XCTestExpectation(description: "Publishes 'Channels' section data received from server.")

        viewModel
            .$channels
            .dropFirst()
            .sink(receiveCompletion: { print($0) }) { media in
                XCTAssert(media.count > 0)
                
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        try viewModel.network.getNetworkData(endpoint: NetworkComm.NetworkEndpoints.channels.rawValue, using: ChannelsData.self)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .sink(receiveCompletion: { print($0) }, receiveValue: { media in
                viewModel.channels = media.channels
            })
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
    }
    
    /// Test network call to retrieve categories.
    /// - Throws: <#description#>
    func testCategoriesDataRetrieval() throws {
        let viewModel = ChannelsViewModel()
        let expectation = XCTestExpectation(description: "Publishes 'Categories' section data received from server.")

        viewModel
            .$categories
            .dropFirst()
            .sink(receiveCompletion: { print($0) }) { media in
                XCTAssert(media.count > 0)
                
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        try viewModel.network.getNetworkData(endpoint: NetworkComm.NetworkEndpoints.categories.rawValue, using: CategoriesData.self)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .sink(receiveCompletion: { print($0) }, receiveValue: { media in
                viewModel.categories = media.categories
            })
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 1)
    }
}
