//
//  StaloZaidimaiScrapper.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-03.
//

import Foundation
import SwiftSoup

class StaloZaidimaiScapper: Scrapper {
    private enum Configs { static let storeId = "stalozaidimai-eu" }
    
    override func currentIterationRequestUrl() -> String {
        return "https://stalozaidimai.eu/shop/page/\(currentIteration)/?per_page=\(biteSize)"
    }
    
    override func extractProducts(from document: Element) -> [Product] {
        guard let productsParent = try? document.select("div.products").first() else {
            print("Failed to get products parent node")
            return []
        }
        
        guard let productsDom = try? productsParent.select("div.product-info") else {
            fatalError("Failed to get products nodes")
        }
        
        let products = productsDom.map(productDomToProduct)
        
        return products
    }
    
    private func productDomToProduct(_ dom: Element) -> Product {
        let name = (try? dom.select("h3.product-title").first()?.text()) ?? "No title"
        
        let priceDom = try? dom.select("span.price").first()
        let isDiscounted: Bool = (try? priceDom?.select("del").first() != nil) ?? false
        
        let priceString = (isDiscounted ? (try? priceDom?.select("ins").first()?.text()) : (try? priceDom?.text()))
        let price = priceStringToDouble(priceString)
        
        var originalPrice: Double? = nil
        if let originalPriceString = try? priceDom?.select("del").first()?.text() {
            originalPrice = priceStringToDouble(originalPriceString)
        }
        
        let availability = (try? dom.select("p.in-stock"))?.first() != nil ? Availability.available : Availability.unavailable
        
        let categories: [String] = (try? dom.select("div.product-cats").first()?.select("a").compactMap{ try? $0.text() }) ?? []
        
        return Product(name: name, price: price, originalPrice: originalPrice, categories: categories, availability: availability, storeId: Configs.storeId)
    }
    
    private func priceStringToDouble(_ price: String?) -> Double {
        Double(price?.replacingOccurrences(of: "€", with: "") ?? "0") ?? 0
    }
}
