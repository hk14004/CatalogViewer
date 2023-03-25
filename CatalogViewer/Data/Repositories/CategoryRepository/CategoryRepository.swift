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
    func refreshCategories(completion: @escaping ()->()) // Add error if needed
    
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
    func refreshCategories(completion: @escaping () -> ()) {
        remoteProvider.getRemoteCategories { [weak self] result in
            switch result {
            case .success(let decodedData):
                // TODO: Optionally inject mapper
                let items: [Category] = decodedData.result.categories.map { item in
                    Category(id: "\(item.id)", parentID: "\(item.parent_id)",
                             imageURL: item.image_url, size: item.size, title: item.title)
                }
                self?.categoriesStore.replace(with: items)
                completion()
            case .failure(let providerError):
                // TODO: Handle error if needed
                print(providerError)
                completion()
            }
        }
    }
    
    func observeCategories() -> AnyPublisher<[Category], Never> {
        categoriesStore.observeList(sortedByKeyPath: Category_DB.PersistedField.title.rawValue,
                                    ascending: true)
    }
    
}
