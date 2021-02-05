//
//  DatabaseRetriever.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-04.
//

import Foundation
import CoreData

class DatabaseRetriever {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getBoardgames(paging: Paging, search: String) -> [Boardgame] {
        let request: NSFetchRequest<Boardgame> = Boardgame.fetchRequest()
        var predicates: [NSPredicate] = []
        
        request.fetchOffset = paging.offset
        request.fetchLimit = paging.limit
        
        if !search.isEmpty {
            predicates.append(NSPredicate(format: "name CONTAINS[cd] %@", search))
        }
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        request.sortDescriptors = [NSSortDescriptor(key: "priceDifference", ascending: false), NSSortDescriptor(key: "lowPrice", ascending: true)]
        
        return (try? context.fetch(request)) ?? []
    }
}

struct Paging {
    let offset: Int
    let limit: Int
}
