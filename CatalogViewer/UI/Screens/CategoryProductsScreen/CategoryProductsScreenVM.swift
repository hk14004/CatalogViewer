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
    private var productsRefreshed: Bool = false
    private lazy var redactedProducts: [Cell] = makeRedactedCells(count: 12)
    
    init(category: Category, productsRepository: ProductRepositoryProtocol) {
        self.category = category
        self.productsRepository = productsRepository
        startup()
    }
}

extension CategoryProductsScreenVM {
    private func startup() {
        Task {
            // Create redacted sections
            sections = makeSections()
            // Load DB cache and display
            await updateProductsSection()
            // Update DB with remote data
            await refreshProducts()
            // Load DB cache and display again, this time we know if there is no data
            await updateProductsSection()
            // Observe and react to DB changes
            observeCachedData()
        }
    }
    
    private func updateProductsSection() async {
        let loaded = await productsRepository.getProducts(categoryIds: [category.id])
        if !productsRefreshed, loaded.isEmpty {
            return
        }
        
        loadedProducts = loaded
        onRenderProducts(list: loaded)
        
    }
    
    private func refreshProducts() async {
        await productsRepository.refreshProducts(categoryIds: [category.id])
        productsRefreshed = true
    }
    
    private func observeCachedData()  {
        bag.productsHandle = productsRepository.observeProducts(categoryIds: [category.id])
            .dropFirst()
            .removeDuplicates()
            .sink { [unowned self] _products in
                loadedProducts = _products
                onRenderProducts(list: _products)
            }
    }
    
    private func onRenderProducts(list: [Product]) {
        func onUpdateUI() {
            let updatedSection = makeProductListSection(items: loadedProducts)
            sections.update(section: updatedSection)
        }
        
        DispatchQueue.main.async {
            if !self.productsRefreshed {
                onUpdateUI()
            } else {
                withAnimation {
                    onUpdateUI()
                }
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
                return redactedProducts
            }
            if loadedCategories.isEmpty {
                if productsRefreshed {
                    return [.nothingToShow]
                } else {
                    return redactedProducts
                }
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
