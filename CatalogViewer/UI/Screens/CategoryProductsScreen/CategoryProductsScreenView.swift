//
//  CategoryProductsScreenView.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import SwiftUI

struct CategoryProductsScreenView: View {
    
    @ObservedObject var viewModel: CategoryProductsScreenVM
    
    var body: some View {
        makeProductsGridView()
    }
    
}

extension CategoryProductsScreenView {
    @ViewBuilder
    private func makeProductsGridView() -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        let data = (1...100).map { "Item \($0)" }
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(data, id: \.self) { item in
                    Text(item)
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func makeProductGridItemView(item: Product) -> some View {
        VStack() {
            Text("Image")
            Text(item.title)
        }
    }
}
