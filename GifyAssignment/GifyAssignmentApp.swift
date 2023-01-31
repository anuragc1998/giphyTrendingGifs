//
//  GifyAssignmentApp.swift
//  GifyAssignment
//
//  Created by macbook on 27/01/23.
//

import SwiftUI

@main
struct GifyAssignmentApp: App {
    
    @StateObject var giphyViewModel = GiphyViewModel(gifLoader: GiphyNetworkService(networkManager: APIRequestManager()), dbHandler: DBHandler())
    
    init() {
        RealmMigrator.setDefaultConfiguration()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(giphyViewModel)
        }
    }
}
