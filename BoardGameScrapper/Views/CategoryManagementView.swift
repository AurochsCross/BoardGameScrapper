//
//  CategoryManagementView.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-03.
//

import SwiftUI

struct CategoryManagementView: View {
    @StateObject var viewModel: CategoryManagementViewModel
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(viewModel.categories, id: \.id) { category in
                        NavigationLink(destination: Text(category.name ?? "NaN")) {
                            Text(category.name ?? "NaN")
                        }
                    }
                }
            }
            
            Divider()
            HStack {
                TextField("Name", text: $viewModel.newCategoryName)
                TextField("Aliases", text: $viewModel.newAliases)
                Button(action: viewModel.createCategory) {
                    Text("Create")
                }
            }
        }
        .padding()
    }
}

struct CategoryManagementView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryManagementView(viewModel: CategoryManagementViewModel(databaseManager: DatabaseManager()))
    }
}
