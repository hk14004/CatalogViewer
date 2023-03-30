//
//  CatalogRepository.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import Combine
import DevToolsRealm

protocol CategoryRepositoryProtocol {
    
    // Remote data
    func refreshCategories() async
    
    // Local data
    func observeCategories() -> AnyPublisher<[Category], Never>
    func getCategories() async -> [Category]

}

class CategoryRepository {
    
    // MARK: Properties
    
    private let remoteProvider: CatalogProviderProtocol
    private let categoriesStore: PersistentRealmStore<Category>
    private let mapper: CategoryResponseMapperProtocol
    
    // MARK: Init
    
    init(remoteProvider: CatalogProviderProtocol, categoriesStore: PersistentRealmStore<Category>, mapper: CategoryResponseMapperProtocol) {
        self.remoteProvider = remoteProvider
        self.categoriesStore = categoriesStore
        self.mapper = mapper
    }
    
}

extension CategoryRepository: CategoryRepositoryProtocol {
    func getCategories() async -> [Category] {
        let key = Category_DB.PersistedField.title.rawValue
        return await categoriesStore.getList(sortedByKeyPath: key, ascending: true)
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
            await categoriesStore.replace(with: items)
        case .failure(let providerError):
            // TODO: Handle error if needed
            print(providerError)
        }
    }
    
    func observeCategories() -> AnyPublisher<[Category], Never> {
        let key = Category_DB.PersistedField.title.rawValue
        return categoriesStore.observeList(sortedByKeyPath: key, ascending: true)
    }
    
}
