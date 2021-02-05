//
//  DatabaseUpdater.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-03.
//

import Foundation
import CoreData

class DatabaseUpdater {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func updateDatabase(with products: [ScrappedProduct]) -> UpdateResult {
        
        var updatedProductIds: [String] = []
        
        products.forEach { scrappedProduct in
            let request: NSFetchRequest<Product> = Product.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", scrappedProduct.id)
            
            if let fetchResults = (try? context.fetch(request)) {
                if fetchResults.count != 0 {
                    let managedObject = fetchResults[0]
                    if ProductUtilities.requiresUpdate(from: managedObject, to: scrappedProduct) {
                        update(managedObject, with: scrappedProduct)
                        updatedProductIds.append(scrappedProduct.id)
                    }
                } else {
                    insert(product: scrappedProduct)
                    updatedProductIds.append(scrappedProduct.id)
                }
            }
        }
        
        return UpdateResult(updatedIds: updatedProductIds)
    }
    
    private func update(_ localProduct: Product, with scrappedProduct: ScrappedProduct) {
        localProduct.availability = scrappedProduct.availability.rawValue
        localProduct.price = scrappedProduct.price
        localProduct.originalPrice = scrappedProduct.originalPrice ?? scrappedProduct.price
        localProduct.lastUpdated = Date()
        
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func insert(product: ScrappedProduct) {
        let categories = retrieveCategories(for: product)
        
        let boardgame = retrieveBoardGame(for: product)
        boardgame.categories = NSSet(array: categories)
        
        let store = retrieveStore(for: product)
        
        let newProduct = Product(context: context)
        newProduct.boardgame = boardgame
        newProduct.availability = product.availability.rawValue
        newProduct.store = store
        newProduct.id = product.id
        newProduct.url = product.url
        newProduct.lastUpdated = Date()
        newProduct.price = product.price
        newProduct.originalPrice = product.originalPrice ?? product.price
        
        var minValue = boardgame.products?.map { $0 as? Product }.map { $0?.price ?? 9999 }.min() ?? 9999
        var maxValue = boardgame.products?.map { $0 as? Product }.map { $0?.originalPrice ?? 0 }.max() ?? 0
        
        minValue = product.price < minValue ? product.price : minValue
        maxValue = product.originalPrice ?? product.price > maxValue ? product.originalPrice ?? product.price : maxValue
        
        boardgame.lowPrice = minValue
        boardgame.highPrice = maxValue
        boardgame.priceDifference = maxValue - minValue
        
        do {
            try context.save()
        } catch {
            print("insert error: \(error)")
        }
    }
    
    private func retrieveBoardGame(for product: ScrappedProduct) -> Boardgame {
        let request: NSFetchRequest<Boardgame> = Boardgame.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", product.name)
        
        if let result = try? context.fetch(request).first {
            return result
        }
        
        let newBoardgame = Boardgame(context: context)
        newBoardgame.name = product.name
        newBoardgame.id = product.name.lowercased().replacingOccurrences(of: " ", with: "-")
        
        return newBoardgame
    }
    
    private func retrieveCategories(for product: ScrappedProduct) -> [Category] {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let predicates = product.categories.map { NSPredicate(format: "aliases CONTAINS[cd] %@", $0.lowercased()) }
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let results = try? context.fetch(request)
        
        if let results = results, results.count > 0 {
            return results
        }
        
        return [getUncategorizedCategory()]
    }
    
    private func retrieveStore(for product: ScrappedProduct) -> Store {
        let request: NSFetchRequest<Store> = Store.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", product.storeId)
        
        if let store = try? context.fetch(request).first {
            return store
        }
        
        let newStore = Store(context: context)
        newStore.id = product.storeId
        newStore.name = product.storeId
        
        return newStore
    }
    
    private func getUncategorizedCategory() -> Category {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", "uncategorized")
        
        let category = try? context.fetch(request).first
        
        if let category = category {
            return category
        }
        
        let newCategory = Category(context: context)
        newCategory.id = "uncategorized"
        newCategory.name = "uncategorized"
        newCategory.aliases = "-"
        
        return newCategory
    }
}

extension DatabaseUpdater {
    struct UpdateResult {
        let updatedIds: [String]
    }
}
