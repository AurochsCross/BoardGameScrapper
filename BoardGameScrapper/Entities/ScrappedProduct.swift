//
//  Product.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-03.
//

import Foundation

struct ScrappedProduct {
    let id: String
    let name: String
    let price: Double
    let originalPrice: Double?
    let categories: [String]
    let availability: Availability
    let storeId: String
    let url: String
    
    init(
        name: String,
        price: Double,
        originalPrice: Double? = nil,
        categories: [String] = [],
        availability: Availability,
        storeId: String = "NaN",
        url: String) {
        self.id = "\(storeId)_\(name.lowercased().replacingOccurrences(of: " ", with: "-"))"
        self.name = name
        self.price = price
        self.originalPrice = originalPrice
        self.categories = categories
        self.availability = availability
        self.storeId = storeId
        self.url = url
    }
    
    var isDiscounted: Bool {
        originalPrice != nil
    }
}

extension ScrappedProduct {
    static var mock: ScrappedProduct {
        ScrappedProduct(
            name: "King's dilemma",
            price: 87,
            originalPrice: 42,
            categories: ["Multiple player", "Euro-game", "Social"],
            availability: .unavailable,
            url: "https://google.com")
    }
}

enum Availability: String {
    case available = "available"
    case unavailable = "unavailable"
}
