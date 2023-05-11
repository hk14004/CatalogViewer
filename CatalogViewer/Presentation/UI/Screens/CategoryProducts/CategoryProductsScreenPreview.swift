//
//  CategoryProductsScreenPreview.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 12/05/2023.
//

import SwiftUI

struct CategoryProductsScreenPreview_Previews: PreviewProvider {
    static var previews: some View {
        CategoryProductsScreenView(viewModel: CategoryProductsScreenVMPreview())
    }
}

fileprivate class CategoryProductsScreenVMPreview {
    var sections: [CategoryProductsScreenSection] = [
        .init(identifier: .productsGrid,
              title: "Grid preview",
              cells: [
                .productGridItem(Product.Preview.makePreview()),
                .productGridItem(Product.Preview.makePreview()),
                .redactedItem(uuid: "1"),
                .redactedItem(uuid: "2")
              ])
    ]
    var navigationDelegate: CategoryProductsScreenVMNavigationDelegate?
}

extension CategoryProductsScreenVMPreview: CategoryProductsScreenVM {
    
    func onTap(product: Product) {
        
    }
    
}
