//
//  CategoriesScreenVM.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import SwiftUI
import Combine
import DevToolsUI

class CategoriesScreenVMImpl: CategoriesScreenVM {
    
    // MARK: Types
    
    class Bag {
        var categoriesHandle: AnyCancellable?
    }
    
    // MARK: Properties
    
    // Public
    weak var navigationDelegate: CategoriesScreenVMNavigationDelegate?
    @Published var sections: [CategoriesScreenSection] = []
    
    // Private
    private let bag = Bag()
    private var loadedCategories: [Category]?
    private let categoryRepository: CategoryRepository
    private var categoriesRefreshed: Bool = false
    private lazy var redactedCategories: [CategoriesScreenSection.Cell] = makeRedactedCells(count: 12)
    
    // MARK: Init
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
        startup()
    }
    
}

// MARK: Public

extension CategoriesScreenVMImpl {
    func onCategoryTapped(item: Category) {
        navigationDelegate?.categoriesScreenVM(vm: self, didSelectCategory: item)
    }
}

// MARK: Private

extension CategoriesScreenVMImpl {
    private func startup() {
        Task {
            // Create redacted sections
            sections = makeSections()
            // Load DB cache and display
            await updateCategoriesSection()
            // Update DB with remote data
            await refreshCategories()
            // Load DB cache and display again, this time we know if there is no data
            await updateCategoriesSection()
            // Observe and react to DB changes
            observeCachedData()
        }
    }
    
    private func updateCategoriesSection() async {
        let loaded = await categoryRepository.getCategories()
        if !categoriesRefreshed, loaded.isEmpty {
            return
        }
        loadedCategories = loaded
        onRenderCategories(list: loaded)
    }
    
    private func refreshCategories() async {
        await categoryRepository.refreshCategories()
        categoriesRefreshed = true
    }
    
    private func observeCachedData() {
        bag.categoriesHandle = categoryRepository.observeCategories()
            .dropFirst()
            .removeDuplicates().sink { [weak self] _categories in
                self?.loadedCategories = _categories
                self?.onRenderCategories(list: _categories)
            }
    }
    
    private func onRenderCategories(list: [Category]) {
        func onUpdateUI() {
            let updatedSection = makeCategoriesListSection(items: loadedCategories)
            sections.update(section: updatedSection)
        }
        
        DispatchQueue.main.async {
            if !self.categoriesRefreshed {
                onUpdateUI()
            } else {
                withAnimation {
                    onUpdateUI()
                }
            }
        }
    }
    
    private func makeSections() -> [CategoriesScreenSection] {
        [
            makeCategoriesListSection(items: loadedCategories)
        ]
    }
    
    private func makeCategoriesListSection(items: [Category]?) -> CategoriesScreenSection {
        let cells: [CategoriesScreenSection.Cell] = {
            guard let loadedCategories = items else {
                return redactedCategories
            }
            if loadedCategories.isEmpty {
                if categoriesRefreshed {
                    return [.nothingToShow]
                } else {
                    return redactedCategories
                }
            } else {
                let loadedCells = loadedCategories.map({CategoriesScreenSection.Cell.categoryItem($0)})
                return loadedCells
            }
            
        }()
        let section = CategoriesScreenSection(identifier: CategoriesScreenSection.Identifier.categoriesList,
                                              title: "Categories", cells: cells)
        return section
    }
    
    private func makeRedactedCells(count: Int) -> [CategoriesScreenSection.Cell]{
        var cells: [CategoriesScreenSection.Cell] = []
        for _ in 0...count - 1 {
            cells.append(.redactedRow(uuid: UUID().uuidString))
        }
        return cells
    }
}
