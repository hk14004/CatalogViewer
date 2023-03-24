//
//  CategoriesScreenView.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import SwiftUI

struct CategoriesScreenView: View {
    
    @ObservedObject var viewModel: CategoriesScreenVM
    
    var body: some View {
        makeCategoriesListView()
            .navigationTitle("Categories list")
    }
    
}

extension CategoriesScreenView {
    @ViewBuilder
    private func makeCategoriesListView() -> some View {
        Text("LiST?")
    }
}
