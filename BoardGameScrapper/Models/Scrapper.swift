//
//  Scrapper.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-01-27.
//

import Foundation
import Combine
import SwiftSoup

class Scrapper {
    let biteSize: Int
    var currentIteration = 1
    
    let chunkScrapped = PassthroughSubject<[Product], Never>()
    
    private var shouldScrape = false
    
    init(biteSize: Int) {
        self.biteSize = biteSize
    }
    
    func scrape() -> [Product] {
        shouldScrape = true
        var result: [Product] = []
        
        while (true) {
            let products = scrapeCurrentIteration()
            
            if products.count > 0 {
                result.append(contentsOf: products)
                
                chunkScrapped.send(products)
                
                nextIteration()
            } else {
                break
            }
            
            if !shouldScrape { break }
        }
        
        
        return result
    }
    
    func stop() {
        shouldScrape = false
    }
    
    private func scrapeCurrentIteration() -> [Product] {
        let url = currentIterationRequestUrl()
        
        guard let content = try? String(contentsOf: URL(string: url)!) else {
            fatalError("Failed to parse url")
        }

        guard let doc: Document = try? SwiftSoup.parse(content) else {
            fatalError("Failed to get document")
        }
        
        return extractProducts(from: doc)
    }
    
    func extractProducts(from document: Element) -> [Product] {
        fatalError("extractProducts(from:) not implemented")
    }
    
    func currentIterationRequestUrl() -> String {
        fatalError("currentIterationRequestUrl() not implemented")
    }
    
    private func nextIteration() {
        currentIteration += 1
    }
}

