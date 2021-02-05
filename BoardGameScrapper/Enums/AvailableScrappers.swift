//
//  AvailableScrappers.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-04.
//

import Foundation

enum AvailableScrappers: CaseIterable {
    case staloZaidimaiEu
    case rikis
    
    func create(chunk: Int, limit: Int?) -> Scrapper {
        switch self {
        case .staloZaidimaiEu:
            return StaloZaidimaiScapper(biteSize: chunk, limit: limit)
        case .rikis:
            return RikisScrapper(biteSize: chunk, limit: limit)
        }
    }
}
