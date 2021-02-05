//
//  BoardgameViewModel.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-04.
//

import Foundation

class BoardgameViewModel: ObservableObject {
    @Published var boardgames: [Boardgame] = []
    
    @Published var search: String = ""
    @Published var loadingState = ProcessState.ready
    
    private var currentPage = 0
    private let pageSize = 100
    
    let databaseManager: DatabaseRetriever = DatabaseRetriever(context: DatabaseManager().context)
    
    func fetchBoardgames() {
        guard loadingState == .ready else {
            return
        }
        
        loadingState = .inProgress
        let loaded = databaseManager.getBoardgames(paging: Paging(offset: pageSize * currentPage, limit: pageSize) ,search: search)
        boardgames.append(contentsOf: loaded)
        
        loadingState = loaded.count < pageSize ? .finished : .ready
        
        currentPage += 1
        print("Loading")
    }
    
    func reload() {
        currentPage = 0
        boardgames = []
        loadingState = .ready
    }
}
