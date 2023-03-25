//
//  ProductRepository.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import Combine
import DevToolsRealm

protocol ProductRepositoryProtocol {
    
    // Remote data
    func refreshProducts(categoryIds: [String], completion: @escaping ()->()) // Add error if needed
    
    // Local data
    func observeProducts(categoryIds: [String]) -> AnyPublisher<[Product], Never>
    func getProducts(categoryIds: [String]) -> [Product]
    
}

class ProductRepository {
    
    // MARK: Properties
    
    private let remoteProvider: CatalogProviderProtocol
    private let store: PersistentRealmStore<Product>
    private let mapper: ProductResponseMapperProtocol
    
    // MARK: Init
    
    init(remoteProvider: CatalogProviderProtocol, store: PersistentRealmStore<Product>, mapper: ProductResponseMapperProtocol) {
        self.remoteProvider = remoteProvider
        self.store = store
        self.mapper = mapper
    }
    
}

extension ProductRepository: ProductRepositoryProtocol {
    func getProducts(categoryIds: [String]) -> [Product] {
        let predcate = makeSearchPredicateForCategories(categoryIds: categoryIds) ?? NSPredicate(value: true)
        return store.getList(predicate: predcate,
                             sortedByKeyPath: Product_DB.PersistedField.title.rawValue,
                             ascending: true)
    }
    
    func refreshProducts(categoryIds: [String], completion: @escaping () -> ()) {
        remoteProvider.getRemoteProducts(categoryIds: categoryIds) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let decodedData):
                let fetchedProducts = self.mapper.map(response: decodedData)
                self.replaceCategoryProducts(withProducts: fetchedProducts, forCategories: categoryIds)
            case .failure(let providerError):
                // TODO: Handle error if needed
                print(providerError)
                
            }
            completion()
        }
    }
    
    func observeProducts(categoryIds: [String]) -> AnyPublisher<[Product], Never> {
        let predcate = makeSearchPredicateForCategories(categoryIds: categoryIds) ?? NSPredicate(value: true)
        return store.observeList(predicate: predcate,
                                 sortedByKeyPath: Product_DB.PersistedField.title.rawValue,
                                 ascending: true)
    }
    
}

// MARK: Private

extension ProductRepository {
    
    @discardableResult
    private func replaceCategoryProducts(withProducts products: [Product], forCategories categoryIds: [String]) -> Bool {
        // 1. Fetch old products and delete them
        // 2. Add new products
        guard let predicate = makeSearchPredicateForCategories(categoryIds: categoryIds) else {
            return false
        }
        let old = store.getList(predicate: predicate)
        store.delete(old, chain: [
            {
                self.store.addOrUpdate(products)
            }
        ])
        
        return true
    }
    
    private func makeSearchPredicateForCategories(categoryIds: [String]) -> NSCompoundPredicate? {
        guard !categoryIds.isEmpty else {
            return nil
        }
        
        let predicates = categoryIds.map { categoryID in
            NSPredicate(format: "\(Product_DB.PersistedField.mainCategoryID) == '\(categoryID)'")
        }
        
        let compound = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        return compound
    }
    
}
