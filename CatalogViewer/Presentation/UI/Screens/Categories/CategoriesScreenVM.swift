//
//  CategoriesScreenVM.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import SwiftUI
import Combine
import DevToolsUI

protocol CategoriesScreenVMNavigationDelegate: AnyObject {
    func categoriesScreenVM(vm: CategoriesScreenVM, didSelectCategory category: Category)
}

class CategoriesScreenVM: ObservableObject {
    
    // MARK: Types
    
    struct Section: UISectionModelProtocol {

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
    
    class Bag {
        var categoriesHandle: AnyCancellable?
    }
    
    // MARK: Properties
    
    // Public
    weak var navigationDelegate: CategoriesScreenVMNavigationDelegate?
    @Published var sections: [Section] = []
    
    // Private
    private let bag = Bag()
    private var loadedCategories: [Category]?
    private let categoryRepository: CategoryRepository
    private var categoriesRefreshed: Bool = false
    private lazy var redactedCategories: [Section.Cell] = makeRedactedCells(count: 12)
    
    // MARK: Init
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
        startup()
    }
    
}

// MARK: Public

extension CategoriesScreenVM {
    func onCategoryTapped(item: Category) {
        navigationDelegate?.categoriesScreenVM(vm: self, didSelectCategory: item)
    }
}

// MARK: Private

extension CategoriesScreenVM {
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
//            observeCachedData()
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
            .removeDuplicates().sink { [unowned self] _categories in
                loadedCategories = _categories
                onRenderCategories(list: _categories)
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
    
    private func makeSections() -> [Section] {
        [
            makeCategoriesListSection(items: loadedCategories)
        ]
    }
    
    private func makeCategoriesListSection(items: [Category]?) -> Section {
        let cells: [Section.Cell] = {
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
                let loadedCells = loadedCategories.map({Section.Cell.categoryItem($0)})
                return loadedCells
            }
            
        }()
        let section = Section(identifier: Section.Identifier.categoriesList,
                              title: "Categories", cells: cells)
        return section
    }
    
    private func makeRedactedCells(count: Int) -> [Section.Cell]{
        var cells: [Section.Cell] = []
        for _ in 0...count - 1 {
            cells.append(.redactedRow(uuid: UUID().uuidString))
        }
        return cells
    }
}
