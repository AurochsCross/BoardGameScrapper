//
//  ProcessState.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-04.
//

import Foundation

enum ProcessState {
    case ready
    case inProgress
    case finished
    case failed
    
    var stateString: String {
        switch self {
        case .ready: return "ready"
        case .inProgress: return "in progress"
        case .finished: return "finished"
        case .failed: return "failed"
        }
    }
}
