//
//  CategoryProductsScreenVM.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import SwiftUI
import Combine
import DevToolsUI

class CategoryProductsScreenVM: ObservableObject {
    
    // MARK: Types
    
    enum SectionIdentifiers: String {
        case productsGrid
    }
    
    enum Cell: Hashable {
        case productGridItem(Product)
        case redactedItem(uuid: String)
    }
    
    struct Section: UISectionModelProtocol {
        
        let uuid: String
        var title: String
        var cells: [Cell]
        
        init(uuid: String, title: String, cells: [Cell]) {
            self.uuid = uuid
            self.title = title
            self.cells = cells
        }
    }
    
    class Bag {
        var productsHandle: AnyCancellable?
    }
    
    // MARK: Properties
    
    // Public
    //    weak var navigationDelegate: CategoriesScreenVMNavigationDelegate?
    @Published var sections: [Section] = []
    
    // Private
    private let bag = Bag()
    private var loadedProducts: [Product]?
    private let category: Category
    
    init(category: Category) {
        self.category = category
        loadedProducts = makeTestItems()
        sections = makeSections()
    }
    
}

extension CategoryProductsScreenVM {
    private func makeSections() -> [Section] {
        [
            makeProductListSection(items: loadedProducts)
        ]
    }
    
    private func makeProductListSection(items: [Product]?) -> Section {
        let cells: [Cell] = {
            guard let loadedCategories = items else {
                return makeRedactedCells(count: 6)
            }
            let loadedCells = loadedCategories.map({Cell.productGridItem($0)})
            return loadedCells
        }()
        let section = Section(uuid: SectionIdentifiers.productsGrid.rawValue,
                              title: "Featured", cells: cells)
        return section
    }
    
    private func makeTestItems() -> [Product] {
        [
            .init(id: "1", mainCategoryID: "", type: "", typeName: "", title: "ggg", brand: "", model: "", image: "https://s3.staging.printful.com/upload/catalog_category/b1/b1513c82696405fcc316fc611c57f132_t?v=1646395980", variantCount: "", currencyID: ""),
            .init(id: "2", mainCategoryID: "", type: "", typeName: "", title: "qwert", brand: "", model: "", image: "https://imageio.forbes.com/specials-images/imageserve/5d35eacaf1176b0008974b54/0x0.jpg?format=jpg&crop=4560,2565,x790,y784,safe&width=1200", variantCount: "", currencyID: ""),
            .init(id: "3", mainCategoryID: "", type: "", typeName: "", title: "ggg", brand: "", model: "", image: "https://s3.staging.printful.com/upload/catalog_category/b1/b1513c82696405fcc316fc611c57f132_t?v=1646395980", variantCount: "", currencyID: ""),
            .init(id: "4", mainCategoryID: "", type: "", typeName: "", title: "qwert", brand: "", model: "", image: "https://imageio.forbes.com/specials-images/imageserve/5d35eacaf1176b0008974b54/0x0.jpg?format=jpg&crop=4560,2565,x790,y784,safe&width=1200", variantCount: "", currencyID: "")
        ]
    }
    
    private func makeRedactedCells(count: Int) -> [Cell]{
        var cells: [Cell] = []
        for _ in 0...count - 1 {
            cells.append(.redactedItem(uuid: UUID().uuidString))
        }
        return cells
    }
}
