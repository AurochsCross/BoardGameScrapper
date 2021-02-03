//
//  ContentViewModel.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-01-27.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var scrapeBiteSize: String = "10"
    @Published var products: [Product] = []
    @Published var categories: [String] = [""]
    
    @Published var currentCategory: String = ""
    
    private var scrapper: Scrapper?
    
    private var cancellables = Set<AnyCancellable>()
    
    func scrape() {
        cancellables = Set<AnyCancellable>()
        
        guard let biteSize = Int(scrapeBiteSize) else {
            print("Warning: bad bite size")
            return
        }
        
        scrapper = StaloZaidimaiScapper(biteSize: biteSize)
        
        scrapper!.chunkScrapped
            .receive(on: DispatchQueue.main)
            .sink {
                self.products.append(contentsOf: $0)
                self.extractCategories(from: $0)
            }
            .store(in: &cancellables)
        
        DispatchQueue.global(qos: .userInitiated).async {
            _ = self.scrapper!.scrape()
        }
    }
    
    func extractCategories(from products: [Product]) {
        categories = Array(Set(ProductUtilities.availableCategories(from: products)).union(Set(categories))).sorted(by: <)
    }
    
    func stopScrapping() {
        scrapper?.stop()
        scrapper = nil
        cancellables = Set<AnyCancellable>()
    }
    
    func export() {
        Exporter().export(products: products)
    }
}
