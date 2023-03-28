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
    
    enum SectionIdentifiers: String {
        case categoriesList
    }
    
    enum Cell: Hashable {
        case categoryItem(Category)
        case redactedRow(uuid: String)
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
        var categoriesHandle: AnyCancellable?
    }
    
    // MARK: Properties
    
    // Public
    weak var navigationDelegate: CategoriesScreenVMNavigationDelegate?
    @Published var sections: [Section] = []
    
    // Private
    private let bag = Bag()
    private var loadedCategories: [Category]?
    private let categoryRepository: CategoryRepositoryProtocol
    
    // MARK: Init
    
    init(categoryRepository: CategoryRepositoryProtocol) {
        self.categoryRepository = categoryRepository
        sections = makeSections()
        refreshRemoteData()
        observeLocalData()
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
    private func refreshRemoteData() {
        Task {
            await categoryRepository.refreshCategories()
        }
        
    }
    
    private func observeLocalData() {
        bag.categoriesHandle = categoryRepository.observeCategories().removeDuplicates().sink { [weak self] _categories in
            self?.onLocalCategoriesUpdated(list: _categories)
        }
    }
    
    private func onLocalCategoriesUpdated(list: [Category]) {
        func onUpdateUI() {
            let updatedSection = makeCategoriesListSection(items: loadedCategories)
            sections.update(section: updatedSection)
        }
        
        let initialLoad: Bool = loadedCategories == nil
        loadedCategories = list
        
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
            makeCategoriesListSection(items: loadedCategories)
        ]
    }
    
    private func makeCategoriesListSection(items: [Category]?) -> Section {
        let cells: [Cell] = {
            guard let loadedCategories = items else {
                return makeRedactedCells(count: 9)
            }
            if loadedCategories.isEmpty {
                return [.nothingToShow]
            } else {
                let loadedCells = loadedCategories.map({Cell.categoryItem($0)})
                return loadedCells
            }
            
        }()
        let section = Section(uuid: SectionIdentifiers.categoriesList.rawValue,
                              title: "Categories", cells: cells)
        return section
    }
    
    private func makeTestItems() -> [Category] {
        return [
            .init(id: "1", parentID: "", imageURL: "", size: "", title: "T-Shirt"),
            .init(id: "2", parentID: "", imageURL: "", size: "", title: "Not a T-Shirt")
        ]
    }
    
    private func makeRedactedCells(count: Int) -> [Cell]{
        var cells: [Cell] = []
        for _ in 0...count - 1 {
            cells.append(.redactedRow(uuid: UUID().uuidString))
        }
        return cells
    }
}
