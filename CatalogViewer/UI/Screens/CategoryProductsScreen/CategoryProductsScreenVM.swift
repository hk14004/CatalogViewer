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
        case nothingToShow
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
    private let productsRepository: ProductRepositoryProtocol
    
    init(category: Category, productsRepository: ProductRepositoryProtocol) {
        self.category = category
        self.productsRepository = productsRepository
        sections = makeSections()
        refreshRemoteData()
        observeLocalData()
    }
    
}

extension CategoryProductsScreenVM {
    private func refreshRemoteData() {
        productsRepository.refreshProducts(categoryIds: [category.id]) {
            print("Refreshed products")
        }
    }
    
    private func observeLocalData() {
        bag.productsHandle = productsRepository.observeProducts(categoryIds: [category.id]).removeDuplicates().sink { [weak self] _products in
            self?.onLocalProductsUpdated(list: _products)
        }
    }
    
    private func onLocalProductsUpdated(list: [Product]) {
        func onUpdateUI() {
            let updatedSection = makeProductListSection(items: loadedProducts)
            sections.update(section: updatedSection)
        }
        
        let initialLoad: Bool = loadedProducts == nil
        loadedProducts = list
        
        // Update UI
        
        if initialLoad {
            onUpdateUI()
        } else {
            withAnimation {
                onUpdateUI()
            }
        }
    }
    
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
            if loadedCategories.isEmpty {
                return [.nothingToShow]
            } else {
                let loadedCells = loadedCategories.map({Cell.productGridItem($0)})
                return loadedCells
            }
            
        }()
        let section = Section(uuid: SectionIdentifiers.productsGrid.rawValue,
                              title: "Featured", cells: cells)
        return section
    }
    
    private func makeRedactedCells(count: Int) -> [Cell]{
        var cells: [Cell] = []
        for _ in 0...count - 1 {
            cells.append(.redactedItem(uuid: UUID().uuidString))
        }
        return cells
    }
}
