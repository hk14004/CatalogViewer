//
//  CategoryProductsScreenCommon.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 12/05/2023.
//

import Foundation
import DevToolsUI

protocol CategoryProductsScreenVMNavigationDelegate: AnyObject {
    func categoryProductsScreenVM(vm: any CategoryProductsScreenVM, showProductDetails product: Product)
}

protocol CategoryProductsScreenVM: ObservableObject {
    var sections: [CategoryProductsScreenSection] { get }
    var navigationDelegate: CategoryProductsScreenVMNavigationDelegate? { get set }
    func onTap(product: Product)
}

class CategoryProductsScreenSection: UISectionModelProtocol {

    enum Identifier: String, CaseIterable {
        case productsGrid
    }
    
    enum Cell: Hashable {
        // TODO: Add cells as viewmodels
        case productGridItem(Product)
        case redactedItem(uuid: String)
        case nothingToShow
    }
    
    let identifier: Identifier
    var title: String
    var cells: [Cell]
    
    init(identifier: Identifier, title: String, cells: [Cell]) {
        self.identifier = identifier
        self.title = title
        self.cells = cells
    }
}
