//
//  DataManager.swift
//  MindValley
//
//  Created by Yura on 6/30/22.
//

import Foundation
import Combine

/// Main Data manipulation class for `Channels`
final class ChannelsViewModel: ObservableObject {
    var subscriptions = [AnyCancellable]()
    
    @Published var episodes = [Media]() {
        willSet {
            
        }
    }
    @Published var channels = [ChannelsData.Channel]()
    @Published var categories = [CategoriesData.Category]()
    @Published var sessionStatus: SessionStatus = SessionStatus.unknown {
        willSet {
            
        }
    }
    public enum SessionStatus: Error {
        case downloaded, downloading, networkError, unknown
    }
    
    let network = NetworkComm()
    
    init() { }
    // MARK: Data Retrieval
    /// Load JSON data from local storage or network responses.
    public func getSectionData() async {
        do {
            updateStatus(status: .downloading)
            
            struct JsonFileNames {
                let episodesFileName = "episodes"
                let channelsFileName = "channels"
                let categoriesFileName = "categories"
            }
            
            /// Attempt loading JSON data from local storage.
            /// - Throws: If data is not readable or decodable.
            /// - Returns: Keep track of how many files have been loaded. If the # is less than the total, initiate network calls.
            func loadingLocalCopies() throws -> Int {
                var fileLoadCount = 0
                
                if let episodesData = try loadCachedJSON(from: JsonFileNames().episodesFileName, reading: EpisodesData.self) {
                    self.episodes = episodesData.data.media; fileLoadCount += 1
                }
                
                if let channelsData = try loadCachedJSON(from: JsonFileNames().channelsFileName, reading: ChannelsData.self) {
                    self.channels = channelsData.data.channels; fileLoadCount += 1
                }
                
                if let categoriesData = try loadCachedJSON(from: JsonFileNames().categoriesFileName, reading: CategoriesData.self) {
                    self.categories = categoriesData.data.categories; fileLoadCount += 1
                }
                
                func loadCachedJSON<T: Decodable>(from file: String, reading type: T.Type) throws -> T? where T: NetworkResponse {
                    let (localFileURL, localFileData) = try readFromFileCache(fileID: file)
                    
                    if let _ = localFileURL, let data = localFileData {
                        print("Using local copy of the \(file) JSON file.")
                        
                        return try JSONDecoder().decode(type, from: data)
                    }
                    return nil
                }
                
                return fileLoadCount
            }
            
            /// Start making network calls, because the data is not present locally or is corrupted.
            ///
            /// Save data locally after the retrieval is complete. Completion happens when all publishers report in.
            /// - Throws: `NetworkComm.NetworkErrors`
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
            
            if try loadingLocalCopies() < 3 {
                try startNetworkRequests()
            } else {
                updateStatus(status: .downloaded)
            }
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
    
    /// Get file ID from the last component of the URL.
    /// - Parameter path: Remote URL.
    /// - Returns: File ID.
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
    
    /// Read file contents if it exists.
    /// - Parameter fileID: File name.
    /// - Returns: If file exists in the `Caches` directory, return its `URL` and contents.
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
