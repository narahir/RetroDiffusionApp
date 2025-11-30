//
//  RetroDiffusionAppApp.swift
//  RetroDiffusionApp
//
//  Created by Thomas Ricouard on 29/11/25.
//

import SwiftUI

@main
struct RetroDiffusionAppApp: App {
    @State private var networking = NetworkClient()
    @State private var libraryManager = LibraryManager()
    @State private var generationQueue = GenerationQueue()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(networking)
                .environment(libraryManager)
                .environment(generationQueue)
                .onAppear {
                    generationQueue.setDependencies(networkClient: networking, libraryManager: libraryManager)
                }
        }
    }
}
