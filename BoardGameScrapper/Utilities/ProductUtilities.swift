//
//  ProductUtilities.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-03.
//

import Foundation

class ProductUtilities {
    static func availableCategories(from products: [Product]) -> [String] {
        var categories = Set<String>()
        
        products.forEach { product in
            product.categories.forEach { categories.insert($0) }
        }
        
        return Array(categories)
    }
}
