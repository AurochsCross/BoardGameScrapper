//
//  ContentView.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-01-27.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @State var showUnavailable = true
    @State var showOnlyDiscount = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Scrapped: \(viewModel.products.count)")
                Spacer()
                TextField("Chunk size", text: $viewModel.scrapeBiteSize)
                    .frame(width: 100)
                Button(action: viewModel.scrape) {
                    Text("Scrape")
                }
                Button(action: viewModel.stopScrapping) {
                    Text("Stop")
                }
                Button(action: viewModel.export) {
                    Text("Export")
                }
            }
            .padding()
            Divider()
            VStack {
                HStack {
                    Picker("Category", selection: $viewModel.currentCategory, content: {
                        ForEach(viewModel.categories, id: \.self) {
                            Text($0)
                        }
                    })
                    
                    Toggle("Show unavailable", isOn: $showUnavailable)
                    Toggle("Show discount only", isOn: $showOnlyDiscount)
                }
                Divider()
                NavigationView {
                    List {
                        ForEach(products, id: \.name) { product in
                            NavigationLink(
                                destination: ProductDetailsView(product: product),
                                label: {
                                    ProductRow(product: product)
                                        .frame(idealWidth: 200)
                                })
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        .padding()
        .frame(minWidth: 300, minHeight: 200)
    }
    
    var products: [ScrappedProduct] {
        var result = viewModel.products
        
        if !viewModel.currentCategory.isEmpty {
            result = result.filter { $0.categories.contains(viewModel.currentCategory) }
        }
        
        if !showUnavailable {
            result = result.filter { $0.availability == .available }
        }
        
        if showOnlyDiscount {
            result = result.filter { $0.isDiscounted }
        }
        
        return result
    }
    
    struct ProductRow: View {
        let product: ScrappedProduct
        var body: some View {
            HStack(spacing: 8) {
                Text(product.name)
                    .foregroundColor(product.availability == .available ? .white : .red)
                Spacer()
                if product.isDiscounted {
                    Text("\(String(format: "%.2f", product.originalPrice!))€")
                        .strikethrough()
                        .foregroundColor(.gray)
                }
                
                Text("\(String(format: "%.2f", product.price))€")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ContentViewModel()
        
        viewModel.products = [.mock]
        
        let view = ContentView(viewModel: viewModel)
        
        return view
    }
}
