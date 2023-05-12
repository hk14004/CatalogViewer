//
//  CategoriesScreenCommon.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 12/05/2023.
//

import Foundation
import DevToolsUI

protocol CategoriesScreenVMNavigationDelegate: AnyObject {
    func categoriesScreenVM(vm: any CategoriesScreenVM, didSelectCategory category: Category)
}

protocol CategoriesScreenVM: ObservableObject {
    var sections: [CategoriesScreenSection] { get }
    var navigationDelegate: CategoriesScreenVMNavigationDelegate? { get set }
    func onCategoryTapped(item: Category)
}

class CategoriesScreenSection: UISectionModelProtocol {
    
    enum Identifier: String, CaseIterable {
        case categoriesList
    }
    
    enum Cell: Hashable {
        // TODO: Add cells as ViewModels
        case categoryItem(Category)
        case redactedRow(uuid: String)
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
