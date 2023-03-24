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
        List(viewModel.sections, id: \.uuid) { section in
            Section {
                ForEach(section.cells, id: \.self) { cell in
                    switch cell {
                    case .categoryItem(let item):
                        makeCategoryListItemView(item: item)
                            .onTapGesture {
                                viewModel.onCategoryTapped(item: item)
                            }
                    }
                }
            } header: {
                Text(section.title)
            }
        }
    }
    
    @ViewBuilder
    private func makeCategoryListItemView(item: Category) -> some View {
        HStack {
            Text(item.title)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle()) 
    }
}
