//
//  CategoriesScreenVM.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import SwiftUI

protocol CategoriesScreenVMNavigationDelegate: AnyObject {
    func categoriesScreenVM(vm: CategoriesScreenVM, didSelectCategory category: Category)
}

class CategoriesScreenVM: ObservableObject {
    
    weak var navigationDelegate: CategoriesScreenVMNavigationDelegate?
    
}
