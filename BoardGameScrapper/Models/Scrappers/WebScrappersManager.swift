//
//  WebScrappersManager.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-04.
//

import Foundation
import Combine

class WebScrappersManager {
    let scrappers: [Scrapper]
    let scrappedCount = CurrentValueSubject<Int, Never>(0)
    private(set) var currentScrapper = "None"
    
    private var cancellables = Set<AnyCancellable>()
    
    init(scrappers: [Scrapper]) {
        self.scrappers = scrappers
    }
    
    func scrape() -> [ScrappedProduct] {
        var result: [ScrappedProduct] = []
        
        scrappers.forEach { scrapper in
            currentScrapper = scrapper.name
            scrapper.chunkScrapped
                .sink { result in
                    self.scrappedCount.value = self.scrappedCount.value + result.count
                }
                .store(in: &cancellables)
            result.append(contentsOf: scrapper.scrape())
            
        }
        
        return result
    }
}
