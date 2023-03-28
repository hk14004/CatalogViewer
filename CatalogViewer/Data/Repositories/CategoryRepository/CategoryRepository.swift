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

}

class CategoryRepository {
    
    // MARK: Properties
    
    private var remoteProvider: CatalogProviderProtocol
    private var categoriesStore: PersistentRealmStore<Category>
    
    // MARK: Init
    
    init(remoteProvider: CatalogProviderProtocol, categoriesStore: PersistentRealmStore<Category>) {
        self.remoteProvider = remoteProvider
        self.categoriesStore = categoriesStore
    }
    
}

extension CategoryRepository: CategoryRepositoryProtocol {
    func refreshCategories() async {
        let result = await withCheckedContinuation { continuation in
            remoteProvider.getRemoteCategories { result in
                continuation.resume(returning: result)
            }
        }
        switch result {
        case .success(let decodedData):
            // TODO: Optionally inject mapper
            let items: [Category] = decodedData.result.categories.map { item in
                Category(id: "\(item.id)", parentID: "\(item.parent_id)",
                         imageURL: item.image_url, size: item.size, title: item.title)
            }
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
