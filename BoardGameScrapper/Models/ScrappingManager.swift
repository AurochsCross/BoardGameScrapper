//
//  ScrappingManager.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-03.
//

import Foundation
import Combine
import CoreData

class ScrappingManager: ObservableObject {
    @Published var chunk: String = "100"
    @Published var limit: String = "100"
    
    @Published var limitEnabled = true
    
    @Published var productsScraped: Int = 0
    
    @Published var shouldScrapeStaloZaidimaiEu = false
    @Published var shouldScrapeRikis = true
    
    @Published var scrapingState = ProcessState.ready
    
    private var cancellables = Set<AnyCancellable>()
    
    let databaseManager = DatabaseManager()
    private var databaseUpdater: DatabaseUpdater
    
    init() {
        databaseUpdater = DatabaseUpdater(context: databaseManager.context)
    }
    
    func scrape() {
        guard let chunkInt = Int(chunk), let limitInt = Int(limit) else {
            print("Error: Chunk and limit is not numbers")
            return
        }
        scrapingState = .inProgress
        
        DispatchQueue.global(qos: .userInitiated).async {
            let scrapedProducts = self.scrapeWeb(chunk: chunkInt, limit: self.limitEnabled ? limitInt : nil)
            let databaseResult = self.updateDatabase(with: scrapedProducts)
            
            DispatchQueue.main.async {
                self.scrapingState = .finished                
            }
        }
    }
    
    func clearDatabase() {
        DatabaseManager().clearDatabase()
    }
    
    private func scrapeWeb(chunk: Int, limit: Int?) -> [ScrappedProduct] {
        DispatchQueue.main.async {
            self.productsScraped = 0
        }
        
        var enabledScrappers: [AvailableScrappers] = []
        
        if shouldScrapeStaloZaidimaiEu {
            enabledScrappers.append(.staloZaidimaiEu)
        }
        
        if shouldScrapeRikis {
            enabledScrappers.append(.rikis)
        }
        
        let scrappers = enabledScrappers.map { $0.create(chunk: chunk, limit: limit) }
        let manager = WebScrappersManager(scrappers: scrappers)
        
        manager.scrappedCount
            .receive(on: DispatchQueue.main)
            .assign(to: \.productsScraped, on: self)
            .store(in: &cancellables)
        
        manager.scrappedCount
            .receive(on: DispatchQueue.main)
            .sink {
                print("scraped count: \($0)")
            }
            .store(in: &cancellables)
        
        return manager.scrape()
    }
    
    private func updateDatabase(with products: [ScrappedProduct]) -> DatabaseUpdater.UpdateResult {
        databaseUpdater = DatabaseUpdater(context: databaseManager.getNewContext())
        return databaseUpdater.updateDatabase(with: products)
    }
}
