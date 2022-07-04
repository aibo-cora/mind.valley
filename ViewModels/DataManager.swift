//
//  DataManager.swift
//  MindValley
//
//  Created by Yura on 6/30/22.
//

import Foundation
import Combine
import Nuke

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
    
    init() {
        configureDiskCaching()
    }
    
    public func getSectionData() async {
        do {
            updateStatus(status: .downloading)
            
            NetworkComm.NetworkEndpoints.allCases.enumerated().forEach { index, endpoint in
                
            }
            let episodePublisher = try network.getNetworkData(endpoint: NetworkComm.NetworkEndpoints.episodes.rawValue, using: EpisodesData.self)
                .receive(on: DispatchQueue.main)
                .map(\.data)
                
            let channelPublisher = try network.getNetworkData(endpoint: NetworkComm.NetworkEndpoints.channels.rawValue, using: ChannelsData.self)
                .receive(on: DispatchQueue.main)
                .map(\.data)
                
            let categoryPublisher = try network.getNetworkData(endpoint: NetworkComm.NetworkEndpoints.categories.rawValue, using: CategoriesData.self)
                .receive(on: DispatchQueue.main)
                .map(\.data)
            
            episodePublisher
                .combineLatest(channelPublisher, categoryPublisher)
                .sink(receiveCompletion: { print($0) }) { [unowned self] mediaList, channelList, categoryList in
                    episodes = mediaList.media
                    channels = channelList.channels
                    categories = categoryList.categories
                    
                    updateStatus(status: .downloaded)
                }
                .store(in: &subscriptions)
        } catch NetworkComm.NetworkErrors.badURL {
            updateStatus(status: .networkError)
        } catch NetworkComm.NetworkErrors.badContents {
            updateStatus(status: .networkError)
        } catch {
            updateStatus(status: .unknown)
        }
    }
    
    /// Update status of the session on main queue.
    /// - Parameter status: New status.
    private func updateStatus(status: SessionStatus) {
        DispatchQueue.main.async { [unowned self] in
            sessionStatus = status
        }
    }
    
    // MARK: Image Caching
    /// Reading from the file system because the data being stored does not contain relations.
    /// Could be refactored to a different persistent storage solution, e.g. `CoreData`.
    /// - Parameter path: Remote URL to the image.
    /// - Returns: Binary data.
    public func loadImage(path: String) -> Data? {
        return try? readFromFileCache(imageID: parseImageID(in: path))
    }
    
    /// Allocate 200Mbs for aggressive image disk caching.
    private func configureDiskCaching() {
        DataLoader.sharedUrlCache.diskCapacity = 0
        
        let pipeline = ImagePipeline {
            let dataCache = try? DataCache(name: "com.yura.mindvalley")
            
            dataCache?.sizeLimit = 200 * 1024 * 1024
            $0.dataCache = dataCache
        }
        ImagePipeline.shared = pipeline
    }
    
    private func parseImageID(in path: String) -> String? {
        if let imageURL = URL(string: path) {
            if let imageID = imageURL.pathComponents.last?.components(separatedBy: ".").first {
                print(imageID)
                
                return imageID
            }
        }
        
        return nil
    }
    
    ///
    /// - Parameter fileURL: URL to file.
    /// - Returns: Image Data.
    private func readFromFileCache(imageID: String?) throws -> Data? {
        func composeImageDataURL(using id: String) -> URL? {
            var outputFile: URL? {
                get {
                    guard let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }

                    return paths.appendingPathComponent(id)
                }
            }
            return outputFile
        }
        
        if let imageID = imageID {
            if let imageDataURL = composeImageDataURL(using: imageID) {
                if FileManager.default.fileExists(atPath: imageDataURL.path) {
                    return try Data(contentsOf: imageDataURL)
                }
            }
        }
        
        return nil
    }
    
    private func writeToCache(fileURL: URL) {
        
    }
}


actor ImageCache {
    
}
