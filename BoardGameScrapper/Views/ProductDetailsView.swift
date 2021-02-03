//
//  ProductDetailsView.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-03.
//

import SwiftUI

struct ProductDetailsView: View {
    let product: Product
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.largeTitle)
                
                if product.availability == .unavailable {
                    Text("Currently unavailable")
                        .bold()
                        .foregroundColor(.red)
                }
                
                HStack(alignment: .bottom) {
                    Text("\(String(format: "%.2f", product.price))€")
                        .font(.title)
                    if let originalPrice = product.originalPrice {
                        Text("\(String(format: "%.2f", originalPrice))€")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .strikethrough()
                    }
                }
                Divider()
                Text("Categories")
                    .font(.headline)
                ForEach(product.categories, id: \.self) {
                    Text($0)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailsView(product: .mock)
            .frame(width: 300, height: 500)
    }
}
