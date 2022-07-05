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
    
    @Published private(set) var episodes = [Media]() {
        willSet {
            
        }
    }
    @Published var channels = [ChannelsData.Channel]()
    @Published var categories = [CategoriesData.Category]()
    
    public enum SessionStatus: Error {
        case downloaded, downloading, networkError, unknown, fileWritingOperation
    }
    @Published var sessionStatus: SessionStatus = SessionStatus.unknown {
        willSet {
            
        }
    }
    
    let network = NetworkComm()
    
    init() {
        configureDiskCaching()
    }
    
    public func getSectionData() async {
        do {
            updateStatus(status: .downloading)
            
            struct JsonFileNames {
                let episodesFileName = "episodes"
                let channelsFileName = "channels"
                let categoriesFileName = "categories"
            }
            
            func loadingLocalCopies() throws {
                let (localEpisodesURL, localEpisodesdata) = try readFromFileCache(fileID: JsonFileNames().episodesFileName)
                if let _ = localEpisodesURL, let data = localEpisodesdata {
                    print("Using local copy of the episodes JSON file.")
                    
                    self.episodes = try JSONDecoder().decode(EpisodesData.self, from: data).data.media
                }
                
                let (localChannelsURL, localChannelsdata) = try readFromFileCache(fileID: JsonFileNames().channelsFileName)
                if let _ = localChannelsURL, let data = localChannelsdata {
                    print("Using local copy of the channel JSON file.")
                    
                    self.channels = try JSONDecoder().decode(ChannelsData.self, from: data).data.channels
                }
                
                let (localCategoriesURL, localCategoriesData) = try readFromFileCache(fileID: JsonFileNames().categoriesFileName)
                if let _ = localCategoriesURL, let data = localCategoriesData {
                    print("Using local copy of the categories JSON file.")
                    
                    self.categories = try JSONDecoder().decode(CategoriesData.self, from: data).data.categories
                }
                
                func loadLocalFile<T: Decodable>(from file: String, reading type: T.Type) throws -> T where T: NetworkResponse {
                    
                }
            }
            
            try loadingLocalCopies()
            
            func startNetworkRequests() throws {
                let episodePublisher = try network.getNetworkData(endpoint: NetworkComm.NetworkEndpoints.episodes.rawValue, using: EpisodesData.self)
                    .receive(on: DispatchQueue.main)
                    
                let channelPublisher = try network.getNetworkData(endpoint: NetworkComm.NetworkEndpoints.channels.rawValue, using: ChannelsData.self)
                    .receive(on: DispatchQueue.main)
                    
                let categoryPublisher = try network.getNetworkData(endpoint: NetworkComm.NetworkEndpoints.categories.rawValue, using: CategoriesData.self)
                    .receive(on: DispatchQueue.main)
                
                episodePublisher
                    .combineLatest(channelPublisher, categoryPublisher)
                    .sink(receiveCompletion: { print($0) }) { [unowned self] mediaList, channelList, categoryList in
                        episodes = mediaList.data.media
                        channels = channelList.data.channels
                        categories = categoryList.data.categories
                        
                        do {
                            try mediaList.write(to: composeFileDataURL(with: JsonFileNames().episodesFileName))
                            try channelList.write(to: composeFileDataURL(with: JsonFileNames().channelsFileName))
                            try categoryList.write(to: composeFileDataURL(with: JsonFileNames().categoriesFileName))
                        } catch {
                            print("Error saving local JSON copies.")
                        }
                        
                        updateStatus(status: .downloaded)
                    }
                    .store(in: &subscriptions)
            }
            
            try startNetworkRequests()
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
    
    // MARK: Caching
    /// Reading from the file system because the data being stored does not contain relations.
    /// Could be refactored to a different persistent storage solution, e.g. `CoreData`.
    /// - Parameter path: Remote URL to the image.
    /// - Returns: Binary data.
    public func loadImage(path: String) -> Data? {
        return try? readFromFileCache(fileID: parseImageID(in: path)).1
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
                return imageID
            }
        }
        
        return nil
    }
    
    func composeFileDataURL(with id: String) -> URL? {
        var outputFile: URL? {
            get {
                guard let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }

                return paths.appendingPathComponent(id)
            }
        }
        return outputFile
    }
    
    ///
    /// - Parameter fileURL: URL to file.
    /// - Returns: File data.
    private func readFromFileCache(fileID: String?) throws -> (URL?, Data?) {
        if let fileID = fileID {
            if let fileDataURL = composeFileDataURL(with: fileID) {
                if FileManager.default.fileExists(atPath: fileDataURL.path) {
                    return try (fileDataURL, Data(contentsOf: fileDataURL))
                }
            }
        }
        return (nil, nil)
    }
    
    private func writeToCache(fileURL: URL) {
        
    }
}


actor ImageCache {
    
}
