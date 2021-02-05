//
//  RikisScrapper.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-04.
//

import Foundation
import SwiftSoup

class RikisScrapper: Scrapper {
    private enum Configs { static let storeId = "rikis" }
    
    override var name: String {
        "Rikis.lt"
    }
    
    override func currentIterationRequestUrl() -> String {
        return "https://www.rikis.lt/parduotuve/page/\(currentIteration)/?product_count=\(biteSize)"
    }
    
    override func extractProducts(from document: Element) -> [ScrappedProduct] {
        guard let productsParent = try? document.select("ul.products").first() else {
            print("Failed to get products parent node")
            return []
        }
        
        guard let productsDom = try? productsParent.select("div.fusion-product-wrapper") else {
            fatalError("Failed to get products nodes")
        }
        
        let products = productsDom.map(productDomToProduct)
        
        return products
    }
    
    private func productDomToProduct(_ dom: Element) -> ScrappedProduct {
        let name = (try? dom.select("h3.product-title").first()?.text()) ?? "No title"
        
        let priceDom = try? dom.select("span.price").first()
        let isDiscounted: Bool = (try? priceDom?.select("del").first() != nil) ?? false
        
        let priceString = (isDiscounted ? (try? priceDom?.select("ins").first()?.text()) : (try? priceDom?.text()))
        let price = priceStringToDouble(priceString)
        
        var originalPrice: Double? = nil
        if let originalPriceString = try? priceDom?.select("del").first()?.text() {
            originalPrice = priceStringToDouble(originalPriceString)
        }
        
        let availability = (try? dom.select("div.fusion-out-of-stock"))?.first() == nil ? Availability.available : Availability.unavailable
        
        let categories: [String] = []
        
        let url = (try? dom.select("h3.product-title").first()?.select("a").first()?.attr("href")) ?? currentIterationRequestUrl()
        
        return ScrappedProduct(
            name: name,
            price: price,
            originalPrice: originalPrice,
            categories: categories,
            availability: availability,
            storeId: Configs.storeId,
            url: url)
    }
    
    private func priceStringToDouble(_ price: String?) -> Double {
        Double(price?.replacingOccurrences(of: "€", with: "") ?? "0") ?? 0
    }
}
