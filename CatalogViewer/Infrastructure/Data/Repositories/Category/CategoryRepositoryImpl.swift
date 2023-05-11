//
//  CatalogProvider.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 12/05/2023.
//

import Foundation
import DevToolsCore
import Combine

class CategoryRepositoryImpl {
    
    // MARK: Properties
    
    private let remoteProvider: CatalogProvider
    private let categoryStore: BasePersistedLayerInterface<Category>
    private let mapper: CategoryResponseMapper
    
    // MARK: Init
    
    init(remoteProvider: CatalogProvider,
         categoriesStore: BasePersistedLayerInterface<Category>,
         mapper: CategoryResponseMapper) {
        self.remoteProvider = remoteProvider
        self.categoryStore = categoriesStore
        self.mapper = mapper
    }
    
}

extension CategoryRepositoryImpl: CategoryRepository {
    func getCategoryPage(pageOptions: PagedRequestOptions) async -> PagedResult<Category> {
        let key = Category_CD.PersistedField.title.rawValue
        return await categoryStore.getListPage(pageOptions: pageOptions,
                                               predicate: NSPredicate(value: true),
                                               sortedByKeyPath: key, ascending: true)
    }
    
    func getCategories() async -> [Category] {
        let key = Category_CD.PersistedField.title.rawValue
        return await categoryStore.getList(predicate: NSPredicate(value: true), sortedByKeyPath: key, ascending: true)
    }
    
    func refreshCategories() async {
        let result = await withCheckedContinuation { continuation in
            remoteProvider.getRemoteCategories { result in
                continuation.resume(returning: result)
            }
        }
        switch result {
        case .success(let decodedData):
            let items = mapper.map(response: decodedData)
            await categoryStore.replace(with: items)
        case .failure(let providerError):
            // TODO: Handle error if needed
            print(providerError)
        }
    }
    
    func observeCategories() -> AnyPublisher<[Category], Never> {
        let key = Category_CD.PersistedField.title.rawValue
        return categoryStore.observeList(predicate: NSPredicate(value: true), sortedByKeyPath: key, ascending: true)
    }
    
}
