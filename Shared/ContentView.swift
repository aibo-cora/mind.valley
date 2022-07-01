//
//  ContentView.swift
//  Shared
//
//  Created by Yura on 6/30/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    
    @ViewBuilder var body: some View {
        VStack {
            switch dataManager.sessionStatus {
            case .downloaded:
                Text("Hi, World.")
            default:
                ProgressView()
                    .task {
                        await dataManager.getSectionData()
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
