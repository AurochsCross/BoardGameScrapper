//
//  BoardgameDetailsView.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-04.
//

import SwiftUI

struct BoardgameDetailsView: View {
    let boardgame: Boardgame
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(boardgame.name ?? "NaN")
                            .font(.largeTitle)
                        Spacer()
                    }
                    if !boardgame.isAvailable {
                        Text("Currently unavailable")
                            .bold()
                            .foregroundColor(.red)
                    }
                }
                
                HStack(alignment: .bottom) {
                    Text("\(String(format: "%.2f", boardgame.availableMinPrice))€")
                        .font(.title)
                    
                    Text(String(format: "%.2f€ - %.2f€", boardgame.minPrice, boardgame.maxPrice))
                        .foregroundColor(.gray)
                }
                
                ForEach(boardgame.productsArray, id: \.id) { product in
                    ProductRow(product: product)
                }
                
                ForEach(boardgame.categoriesArray, id: \.id) { category in
                    Text(category.name ?? "NaN")
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
    }
    
    struct ProductRow: View {
        var product: Product
        
        var body: some View {
            HStack {
                Text(String(format: "%.2f", product.price))
                if product.price != product.originalPrice {
                    Text(String(format: "%.2f", product.originalPrice))
                        .strikethrough()
                }
                Link(destination: URL(string: product.url!)!) {
                    Text(product.store?.name ?? "NaN")
                }
                
            }
        }
    }
}

struct BoardgameDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BoardgameDetailsView(boardgame: Boardgame.mock)
    }
}
