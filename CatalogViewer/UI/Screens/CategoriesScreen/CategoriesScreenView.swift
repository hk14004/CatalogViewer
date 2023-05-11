//
//  CategoriesScreenView.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import SwiftUI
import Kingfisher

struct CategoriesScreenView: View {
    
    @ObservedObject var viewModel: CategoriesScreenVM
    
    var body: some View {
        makeCategoriesListView()
            .navigationTitle("Browse")
    }
    
}

extension CategoriesScreenView {
    @ViewBuilder
    private func makeCategoriesListView() -> some View {
        List(viewModel.sections, id: \.identifier) { section in
            Section {
                ForEach(section.cells, id: \.self) { cell in
                    switch cell {
                    case .categoryItem(let item):
                        makeCategoryListItemView(item: item)
                            .onTapGesture {
                                viewModel.onCategoryTapped(item: item)
                            }
                    case .redactedRow:
                        makeRedactedRow()
                    case .nothingToShow:
                        SuchEmptyView()
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
    
    @ViewBuilder
    private func makeRedactedRow() -> some View {
        let random = String.random(of: Int.random(in: 5...25))
        let redacted = Category(id: "", parentID: "", imageURL: "", size: "", title: random)
        makeCategoryListItemView(item: redacted)
            .redacted(reason: .placeholder)
    }
}
