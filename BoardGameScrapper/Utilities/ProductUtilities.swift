//
//  ProductUtilities.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-03.
//

import Foundation

class ProductUtilities {
    static func availableCategories(from products: [ScrappedProduct]) -> [String] {
        var categories = Set<String>()
        
        products.forEach { product in
            product.categories.forEach { categories.insert($0) }
        }
        
        return Array(categories)
    }
    
    static func requiresUpdate(from localProduct: Product, to scrappedProduct: ScrappedProduct) -> Bool {
        let isSimilar =
            localProduct.availability == scrappedProduct.availability.rawValue &&
            localProduct.price == scrappedProduct.price &&
            localProduct.originalPrice == (scrappedProduct.originalPrice ?? scrappedProduct.price) &&
            localProduct.url == scrappedProduct.url
            
        return !isSimilar
    }
}
