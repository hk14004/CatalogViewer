//
//  ProductScreenView.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 30/03/2023.
//

import SwiftUI
import Kingfisher

struct ProductScreenView: View {
    
    @ObservedObject var viewModel: ProductScreenVM
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                makeImageView(urlString: viewModel.product.image)
                makeDetailsView(item: viewModel.product)
                Spacer()
            }
        }
        .navigationTitle("Details")
    }
    
}

extension ProductScreenView {
    @ViewBuilder
    private func makeImageView(urlString: String) -> some View {
        Rectangle()
            .foregroundColor(Color("RedactedImage"))
            .aspectRatio(1.5, contentMode: .fill)
            .overlay {
                KFImage(URL(string: urlString))
                    .resizable()
                    .fade(duration: 0.3)
                    .forceTransition()
                    .scaledToFit()
            }
            .clipped()
    }
    
    @ViewBuilder
    private func makeDetailsView(item: Product) -> some View {
        VStack(spacing: 0) {
            makeDetailsRowView(title: "Title", info: item.title)
            makeDetailsRowView(title: "Type", info: item.typeName)
                .background(Color("RedactedImage"))
            makeDetailsRowView(title: "Brand", info: item.brand)
            makeDetailsRowView(title: "Model", info: item.model)
                .background(Color("RedactedImage"))
            makeDetailsRowView(title: "Number of variants", info: "\(item.variantCount)")
        }
    }
    
    @ViewBuilder
    private func makeDetailsRowView(title: String, info: String) -> some View {
        HStack() {
            Text(title)
                .fontWeight(.bold)
            Text(info)
                .fontWeight(.light)
            Spacer()
        }
        .padding()
    }
}
