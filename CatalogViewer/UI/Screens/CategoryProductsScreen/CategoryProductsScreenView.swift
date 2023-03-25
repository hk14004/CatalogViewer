//
//  CategoryProductsScreenView.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import SwiftUI
import Kingfisher

struct CategoryProductsScreenView: View {
    
    @ObservedObject var viewModel: CategoryProductsScreenVM
    
    var body: some View {
        List(viewModel.sections, id: \.uuid) { section in
            let sectionID = CategoryProductsScreenVM.SectionIdentifiers.init(rawValue: section.uuid)!
            switch sectionID {
            case .productsGrid:
                makeProductsGridSection(section: section)
            }
        }
    }
    
}

extension CategoryProductsScreenView {
    @ViewBuilder
    private func makeProductsGridSection(section: CategoryProductsScreenVM.Section) -> some View {
        let columns = [
            GridItem(.flexible(), spacing: 20),
            GridItem(.flexible(), spacing: 0)
        ]
        
        Section {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(section.cells, id: \.self) { cell in
                        switch cell {
                        case .productGridItem(let item):
                            makeProductGridItemView(item: item)
                        case .redactedItem:
                            makeProductGridItemViewRedacted()
                        }
                    }
                }
            }
        } header: {
            Text(section.title)
        }
    }
    
    @ViewBuilder
    private func makeProductGridItemView(item: Product) -> some View {
        VStack() {
            Rectangle()
                .foregroundColor(.clear)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    KFImage(URL(string: item.image))
                        .resizable()
                        .scaledToFill()
                        .clipped()
                }
                .cornerRadius(12)
            Text(item.title)
                .fontWeight(.medium)
        }
        .padding(.top)
    }
    
    @ViewBuilder
    private func makeProductGridItemViewRedacted() -> some View {
        VStack() {
            Rectangle()
                .foregroundColor(.clear)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    Image(systemName: "placeholdertext.fill")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                }
                .cornerRadius(12)
            Text(String.random(of: Int.random(in: 6...18)))
        }
        .padding(.top)
        .redacted(reason: .placeholder)
    }
}
