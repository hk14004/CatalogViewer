//
//  CategoriesScreenPreview.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 12/05/2023.
//

import SwiftUI

struct CategoriesScreenView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesScreenView(viewModel: CategoriesScreenVMPreview())
    }
}

fileprivate class CategoriesScreenVMPreview {
    var navigationDelegate: CategoriesScreenVMNavigationDelegate?
    var sections: [CategoriesScreenSection] = [
        .init(identifier: .categoriesList,
              title: "Preview categories",
              cells: [
                .categoryItem(Category(id: "0", parentID: "0", imageURL: "", size: "", title: "Preview navigation row"))
              ])
    ]
}

extension CategoriesScreenVMPreview: CategoriesScreenVM {
    func onCategoryTapped(item: Category) {
        
    }
}
