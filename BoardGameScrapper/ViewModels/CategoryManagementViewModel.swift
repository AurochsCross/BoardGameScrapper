//
//  CategoryManagementViewModel.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-03.
//

import Foundation

class CategoryManagementViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var newCategoryName: String = ""
    @Published var newAliases: String = ""
    
    private let databaseManager: DatabaseManager
    
    init(databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
        loadCategories()
    }
    
    private func loadCategories() {
        do {
            categories = try databaseManager.context.fetch(Category.fetchRequest())
        } catch {
            print("Error: \(error)")
        }
    }
    
    func createCategory() {
        guard !newCategoryName.isEmpty, !newAliases.isEmpty else {
            return
        }
        
        let category = Category.init(context: databaseManager.context)
        category.id = UUID().uuidString
        category.name = newCategoryName
        category.aliases = newAliases
        
        databaseManager.saveContext()
        categories.append(category)
        
        newCategoryName = ""
        newAliases = ""
    }
}
