//
//  Boardgame+UI.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-04.
//

import Foundation
import CoreData


extension Boardgame {
    var availableMinPrice: Double {
        self.products?
            .compactMap { product in
                let product = product as? Product
                
                if !(product?.isAvailable ?? false) {
                    return nil
                }
                
                return product?.price
            }
            .min() ?? 0
    }
    
    var minPrice: Double {
        self.products?
            .compactMap { product in
                let product = product as? Product
                
                return product?.price
            }
            .min() ?? 0
    }
    
    var maxPrice: Double {
        self.products?
            .compactMap { product in
                let product = product as? Product
                
                return product?.price
            }
            .max() ?? 0
    }
    
    var maxOriginalPrice: Double {
        self.products?
            .compactMap { product in
                let product = product as? Product
                
                return product?.originalPrice
            }
            .max() ?? 0
    }
    
    var isAvailable: Bool {
        self.products?.compactMap { $0 as? Product }.first(where: { $0.isAvailable } ) != nil
    }
    
    var productsArray: [Product] {
        self.products?.compactMap { $0 as? Product } ?? []
    }
    
    var categoriesArray: [Category] {
        self.categories?.compactMap { $0 as? Category } ?? []
    }
    
}

extension Product {
    var isAvailable: Bool { self.availability == "available" }
}

extension Boardgame {
    static var mock: Boardgame {
        return MockBoardgame(
            mockId: "abc",
            mockName: "Heros of the Storm",
            mockCategories: [
                MockCategory(
                    mockId: "a",
                    mockName: "Dice",
                    mockAliases: ""),
                MockCategory(mockId: "b",
                             mockName: "Family",
                             mockAliases: "")],
            mockProducts: [
                MockProduct(mockAvailability: "available", mockId: "a", mockLastUpdated: Date(), mockOriginalPrice: 20, mockPrice: 20, mockUrl: "google.com", mockStore: MockStore(mockId: "a", mockName: "Stalozaidimai.eu")),
                MockProduct(mockAvailability: "available", mockId: "b", mockLastUpdated: Date(), mockOriginalPrice: 30, mockPrice: 18, mockUrl: "google.com", mockStore: MockStore(mockId: "b", mockName: "Rikis.lt"))
            ])
    }
}


class MockBoardgame: Boardgame {
    private var mockId: String = ""
    override var id: String? { get { mockId } set { } }
    
    private var mockName: String = ""
    override var name: String? { get { mockName } set { } }
    
    private var mockCategories: NSSet = []
    override var categories: NSSet? { get { mockCategories} set { } }
    
    private var mockProducts: NSSet = []
    override var products: NSSet? { get { mockProducts } set { } }
    
    convenience init(mockId: String, mockName: String, mockCategories: [MockCategory], mockProducts: [MockProduct]) {
        self.init()
        self.mockId = mockId
        self.mockName = mockName
        self.mockCategories = NSSet(array: mockCategories)
        self.mockProducts = NSSet(array: mockProducts)
    }
}

class MockCategory: Category {
    private var mockAliases: String = ""
    override var aliases: String? { get { mockAliases } set { } }
    
    private var mockId: String = ""
    override var id: String? { get { mockId } set { } }
    
    private var mockName: String = ""
    override var name: String? { get { mockName } set { } }
    
    convenience init(mockId: String, mockName: String, mockAliases: String) {
        self.init()
        self.mockId = mockId
        self.mockName = mockName
        self.mockAliases = mockAliases
    }
}

class MockProduct: Product {
    private var mockAvailability: String = ""
    override var availability: String? { get { mockAvailability } set { } }
    
    private var mockId: String = ""
    override var id: String? { get { mockId } set { } }
    
    private var mockLastUpdated: Date = Date()
    override var lastUpdated: Date? { get { mockLastUpdated } set { } }
    
    private var mockOriginalPrice: Double = 0
    override var originalPrice: Double { get { mockOriginalPrice } set { } }
    
    
    private var mockPrice: Double = 0
    override var price: Double { get { mockPrice } set { } }
    
    private var mockUrl: String = ""
    override var url: String? { get { mockUrl } set { } }
    
    private var mockStore: MockStore = MockStore(mockId: "", mockName: "")
    override var store: Store? { get { mockStore } set { } }
    
    convenience init(mockAvailability: String, mockId: String, mockLastUpdated: Date, mockOriginalPrice: Double, mockPrice: Double, mockUrl: String, mockStore: MockStore) {
        self.init()
        self.mockAvailability = mockAvailability
        self.mockId = mockId
        self.mockLastUpdated = mockLastUpdated
        self.mockOriginalPrice = mockOriginalPrice
        self.mockPrice = mockPrice
        self.mockUrl = mockUrl
        self.mockStore = mockStore
    }
}

class MockStore: Store {
    private var mockId: String = ""
    override var id: String? { get { mockId } set { } }
    
    private var mockName: String = ""
    override var name: String? { get { mockName } set { } }
    
    convenience init(mockId: String, mockName: String) {
        self.init()
        self.mockId = mockId
        self.mockName = mockName
    }
}
