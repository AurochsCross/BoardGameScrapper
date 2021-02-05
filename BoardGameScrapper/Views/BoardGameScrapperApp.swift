//
//  BoardGameScrapperApp.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-01-27.
//

import SwiftUI

@main
struct BoardGameScrapperApp: App {
    @StateObject var appViewModel = AppViewModel()
    var body: some Scene {
        WindowGroup {
            BoardgameView(viewModel: BoardgameViewModel())
        }
        
        WindowGroup("Categories") {
            CategoryManagementView(viewModel: CategoryManagementViewModel(databaseManager: DatabaseManager()))
                .frame(minWidth: 300, minHeight: 300)
        }
        
        WindowGroup("Scraping") {
            ScrapingView(scrapeManager: ScrappingManager())
                .frame(minWidth: 300, minHeight: 300)
        }
    }
}
