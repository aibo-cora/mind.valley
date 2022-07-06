//
//  DataCaching.swift
//  MindValley
//
//  Created by Yura on 7/6/22.
//

import Foundation
import Nuke

final class DataCaching {
    init() {
        configureDataCaching()
    }
    /// Allocate 200Mbs for aggressive image disk caching.
    private func configureDataCaching() {
        DataLoader.sharedUrlCache.diskCapacity = 0
        
        let pipeline = ImagePipeline {
            let dataCache = try? DataCache(name: "com.yura.mindvalley")
            
            dataCache?.sizeLimit = 200 * 1024 * 1024
            $0.dataCache = dataCache
        }
        ImagePipeline.shared = pipeline
    }
}
