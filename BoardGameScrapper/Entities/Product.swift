//
//  Product.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-03.
//

import Foundation

struct Product {
    let name: String
    let price: Double
    let originalPrice: Double?
    let categories: [String]
    let availability: Availability
    let storeId: String
    
    init(
        name: String,
        price: Double,
        originalPrice: Double? = nil,
        categories: [String] = [],
        availability: Availability,
        storeId: String = "NaN") {
        self.name = name
        self.price = price
        self.originalPrice = originalPrice
        self.categories = categories
        self.availability = availability
        self.storeId = storeId
    }
    
    var isDiscounted: Bool {
        originalPrice != nil
    }
}

extension Product {
    static var mock: Product {
        Product(
            name: "King's dilemma",
            price: 87,
            originalPrice: 42,
            categories: ["Multiple player", "Euro-game", "Social"],
            availability: .unavailable)
    }
}

enum Availability {
    case available
    case unavailable
}
