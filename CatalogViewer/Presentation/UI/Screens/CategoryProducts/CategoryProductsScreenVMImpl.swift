//
//  CategoryProductsScreenVM.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import SwiftUI
import Combine
import DevToolsUI

class CategoryProductsScreenVMImpl: CategoryProductsScreenVM {
    
    // MARK: Types
    
    class Bag {
        var productsHandle: AnyCancellable?
    }
    
    // MARK: Properties
    
    // Public
    weak var navigationDelegate: CategoryProductsScreenVMNavigationDelegate?
    @Published var sections: [CategoryProductsScreenSection] = []
    
    // Private
    private let bag = Bag()
    private var loadedProducts: [Product]?
    private let category: Category
    private let productsRepository: ProductRepository
    private var productsRefreshed: Bool = false
    private lazy var redactedProducts: [CategoryProductsScreenSection.Cell] = makeRedactedCells(count: 12)
    
    // MARK: Init
    
    init(category: Category, productsRepository: ProductRepository) {
        self.category = category
        self.productsRepository = productsRepository
        startup()
    }
}

// MARK: Public

extension CategoryProductsScreenVMImpl {
    func onTap(product: Product) {
        navigationDelegate?.categoryProductsScreenVM(vm: self, showProductDetails: product)
    }
}

// MARK: Private

extension CategoryProductsScreenVMImpl {
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
//            observeCachedData()
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
    
    private func makeSections() -> [CategoryProductsScreenSection] {
        [
            makeProductListSection(items: loadedProducts)
        ]
    }
    
    private func makeProductListSection(items: [Product]?) -> CategoryProductsScreenSection {
        let cells: [CategoryProductsScreenSection.Cell] = {
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
                let loadedCells = loadedCategories.map({CategoryProductsScreenSection.Cell.productGridItem($0)})
                return loadedCells
            }
            
        }()
        let section = CategoryProductsScreenSection(identifier: CategoryProductsScreenSection.Identifier.productsGrid,
                              title: "Featured", cells: cells)
        return section
    }
    
    private func makeRedactedCells(count: Int) -> [CategoryProductsScreenSection.Cell]{
        var cells: [CategoryProductsScreenSection.Cell] = []
        for _ in 0...count - 1 {
            cells.append(.redactedItem(uuid: UUID().uuidString))
        }
        return cells
    }
}
