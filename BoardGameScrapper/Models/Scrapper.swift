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
    
    let chunkScrapped = PassthroughSubject<[ScrappedProduct], Never>()
    
    private var shouldScrape = false
    private var limit: Int?
    
    var name: String {
        "NaN"
    }
    
    init(biteSize: Int, limit: Int? = nil) {
        self.biteSize = biteSize
        self.limit = limit
    }
    
    func scrape() -> [ScrappedProduct] {
        shouldScrape = true
        var result: [ScrappedProduct] = []
        
        while (true) {
            let products = scrapeCurrentIteration()
            
            if products.count > 0 {
                result.append(contentsOf: products)
                
                chunkScrapped.send(products)
                nextIteration()
            } else {
                break
            }
            
            if let limit = limit, result.count >= limit {
                stop()
            }
            
            if !shouldScrape { break }
        }
        
        
        return result
    }
    
    func stop() {
        shouldScrape = false
    }
    
    private func scrapeCurrentIteration() -> [ScrappedProduct] {
        let url = currentIterationRequestUrl()
        
        guard let content = try? String(contentsOf: URL(string: url)!) else {
            fatalError("Failed to parse url")
        }

        guard let doc: Document = try? SwiftSoup.parse(content) else {
            fatalError("Failed to get document")
        }
        
        return extractProducts(from: doc)
    }
    
    func extractProducts(from document: Element) -> [ScrappedProduct] {
        fatalError("extractProducts(from:) not implemented")
    }
    
    func currentIterationRequestUrl() -> String {
        fatalError("currentIterationRequestUrl() not implemented")
    }
    
    private func nextIteration() {
        currentIteration += 1
    }
}

