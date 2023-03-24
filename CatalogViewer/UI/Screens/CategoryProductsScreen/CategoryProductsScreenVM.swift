//
//  CategoryProductsScreenVM.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import SwiftUI
import Combine

class CategoryProductsScreenVM: ObservableObject {
    
    // MARK: Properties
    
    // Public
//    weak var navigationDelegate: CategoriesScreenVMNavigationDelegate?
//    @Published var sections: [Section] = []
    
    // Private
//    private let bag = Bag()
    private var loadedProducts: [Product] = []
    private let category: Category
    
    init(category: Category) {
        self.category = category
    }
    
}
