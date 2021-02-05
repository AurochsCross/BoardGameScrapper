//
//  BoardgameView.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-04.
//

import SwiftUI

struct BoardgameView: View {
    @StateObject var viewModel: BoardgameViewModel
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $viewModel.search)
                Button(action: viewModel.reload) {
                    Text("Search")
                }
            }
            NavigationView {
                List {
                    ForEach(viewModel.boardgames, id: \.id) { boardgame in
                        NavigationLink(destination: BoardgameDetailsView(boardgame: boardgame)) {
                            BoardgameRow(boardgame: boardgame)
                        }
                    }
                    if viewModel.loadingState != .finished {
                        Text("Should load")
                            .onAppear {
                                viewModel.fetchBoardgames()
                            }
                    }
                }
            }
        }
        .onAppear {
            viewModel.reload()
        }
        .padding()
    }
    
    struct BoardgameRow: View {
        var boardgame: Boardgame
        
        var body: some View {
            HStack {
                Text("\(boardgame.name ?? "NaN")")
                Spacer()
                Text(String(format: "%.2f Eur", boardgame.availableMinPrice))
                if boardgame.isAvailable && boardgame.availableMinPrice != boardgame.maxOriginalPrice {
                    Text(String(format: "%.2f Eur", boardgame.maxOriginalPrice))
                        .strikethrough()
                        .foregroundColor(.gray)
                }
            }
            .foregroundColor(boardgame.isAvailable ? .white : .gray)
        }
    }
}

struct BoardgameView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BoardgameViewModel()
        
        viewModel.boardgames = [.mock]
        
        return BoardgameView(viewModel: viewModel)
    }
}
