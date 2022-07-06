//
//  MindValleyApp.swift
//  Shared
//
//  Created by Yura on 6/30/22.
//

import SwiftUI

@main
struct MindValleyApp: App {
    let dataCaching = DataCaching()
    
    var body: some Scene {
        WindowGroup {
            ChannelsView()
        }
    }
}
