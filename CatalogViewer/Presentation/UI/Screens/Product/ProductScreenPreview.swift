//
//  ProductScreenPreview.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 12/05/2023.
//

import SwiftUI

struct ProductScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ProductScreenView(viewModel: ProductScreenVMPreview())
    }
}

fileprivate class ProductScreenVMPreview: ProductScreenVM {
    var product: Product = Product.Preview.makePreview()
}
