//
//  CategoryProductsScreenView.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import SwiftUI
import Kingfisher

struct CategoryProductsScreenView<ViewModel: CategoryProductsScreenVM>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        List(viewModel.sections, id: \.identifier) { section in
            switch section.identifier {
            case .productsGrid:
                makeProductsGridSection(section: section)
            }
        }
    }
    
}

extension CategoryProductsScreenView {
    @ViewBuilder
    private func makeProductsGridSection(section: CategoryProductsScreenSection) -> some View {
        let columns: [GridItem] = {
            if section.cells.count > 1 {
                return [
                    GridItem(.flexible(), spacing: 20),
                    GridItem(.flexible(), spacing: 0)
                ]
            } else {
                return [GridItem(.flexible(), spacing: 0)]
            }
        }()
        Section {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(section.cells, id: \.self) { cell in
                    switch cell {
                    case .productGridItem(let item):
                        makeProductGridItemView(item: item)
                            .onTapGesture {
                                viewModel.onTap(product: item)
                            }
                    case .redactedItem:
                        makeProductGridItemViewRedacted()
                    case .nothingToShow:
                        SuchEmptyView()
                    }
                }
            }
        } header: {
            Text(section.title)
        }
    }
    
    @ViewBuilder
    private func makeProductGridItemView(item: Product) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .foregroundColor(Color("RedactedImage"))
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    KFImage(URL(string: item.image))
                        .resizable()
                        .fade(duration: 0.3)
                        .forceTransition()
                        .scaledToFill()
                }
                .clipped()
                .cornerRadius(12)
                .layoutPriority(2)
            Spacer()
            Text(item.title)
                .fontWeight(.medium)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .layoutPriority(1)
            Spacer()
        }
        .padding(.top, 6)
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
