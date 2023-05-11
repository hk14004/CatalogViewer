//
//  CatalogRepository.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import Combine
import DevToolsCore

protocol CategoryRepositoryProtocol {
    
    // Remote data
    func refreshCategories() async
    
    // Local data
    func observeCategories() -> AnyPublisher<[Category], Never>
    func getCategories() async -> [Category]
    func getCategoryPage(pageOptions: PagedRequestOptions) async -> PagedResult<Category>

}

class CategoryRepository {
    
    // MARK: Properties
    
    private let remoteProvider: CatalogProviderProtocol
    private let categoryStore: BasePersistedLayerInterface<Category>
    private let mapper: CategoryResponseMapperProtocol
    
    // MARK: Init
    
    init(remoteProvider: CatalogProviderProtocol,
         categoriesStore: BasePersistedLayerInterface<Category>,
         mapper: CategoryResponseMapperProtocol) {
        self.remoteProvider = remoteProvider
        self.categoryStore = categoriesStore
        self.mapper = mapper
    }
    
}

extension CategoryRepository: CategoryRepositoryProtocol {
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
