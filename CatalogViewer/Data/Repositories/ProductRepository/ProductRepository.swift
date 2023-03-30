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
    func refreshProducts(categoryIds: [String]) async
    func refreshProductDetails(productID: String) async
    
    
    // Local data
    func observeProducts(categoryIds: [String]) -> AnyPublisher<[Product], Never>
    func getProducts(categoryIds: [String]) async -> [Product]
    func observeProduct(id: String) -> AnyPublisher<Product?, Never>
}

class ProductRepository {
    
    // MARK: Properties
    
    private let remoteProvider: CatalogProviderProtocol
    private let productsStore: PersistentRealmStore<Product>
    private let mapper: ProductResponseMapperProtocol
    private let productVariantStore: PersistentRealmStore<ProductVariant>
    
    // MARK: Init
    
    init(remoteProvider: CatalogProviderProtocol, productsStore: PersistentRealmStore<Product>, mapper: ProductResponseMapperProtocol, productVariantStore: PersistentRealmStore<ProductVariant>) {
        self.remoteProvider = remoteProvider
        self.productsStore = productsStore
        self.mapper = mapper
        self.productVariantStore = productVariantStore
    }
    
}

extension ProductRepository: ProductRepositoryProtocol {
    func observeProduct(id: String) -> AnyPublisher<Product?, Never> {
        return productsStore.observeSingle(id: id)
    }
    
    func refreshProductDetails(productID: String) async {
        let result = await withCheckedContinuation({ continuation in
            remoteProvider.getRemoteProductDetails(productID: productID) { result in
                continuation.resume(returning: result)
            }
        })
        
        switch result {
        case .success(let decodedData):
            print(decodedData)
            let fetchedVariants = mapper.map(response: decodedData)
            await replaceProductVariants(withVariants: fetchedVariants, forProduct: productID)
            // TODO: Update product, because we have fresh data
        case .failure(let providerError):
            // TODO: Handle error if needed
            print(providerError)
        }
    }
    
    func getProducts(categoryIds: [String]) async -> [Product] {
        let predcate = makeSearchPredicateForCategories(categoryIds: categoryIds) ?? NSPredicate(value: true)
        return await productsStore.getList(predicate: predcate,
                                   sortedByKeyPath: Product_DB.PersistedField.title.rawValue,
                                   ascending: true)
    }
    
    func refreshProducts(categoryIds: [String]) async {
        let result = await withCheckedContinuation({ continuation in
            remoteProvider.getRemoteProducts(categoryIds: categoryIds) { result in
                continuation.resume(returning: result)
            }
        })
        
        switch result {
        case .success(let decodedData):
            let fetchedProducts = self.mapper.map(response: decodedData)
            await replaceCategoryProducts(withProducts: fetchedProducts, forCategories: categoryIds)
        case .failure(let providerError):
            // TODO: Handle error if needed
            print(providerError)
        }
    }
    
    func observeProducts(categoryIds: [String]) -> AnyPublisher<[Product], Never> {
        let predcate = makeSearchPredicateForCategories(categoryIds: categoryIds) ?? NSPredicate(value: true)
        return productsStore.observeList(predicate: predcate,
                                 sortedByKeyPath: Product_DB.PersistedField.title.rawValue,
                                 ascending: true)
    }
    
}

// MARK: Private

extension ProductRepository {
    
    private func replaceProductVariants(withVariants variants: [ProductVariant], forProduct productID: String) async {
        // 1. Fetch old variants and delete them
        // 2. Add new variants
        let predicate = NSPredicate(format: "\(ProductVariant_DB.PersistedField.productId) == '\(productID)'")
        let old = await productVariantStore.getList(predicate: predicate)
        let _store = productVariantStore
        await _store.bulkWrite(operations: [
            {await _store.delete(old)},
            {await _store.addOrUpdate(variants)},
        ])
    }
    
    private func replaceCategoryProducts(withProducts products: [Product], forCategories categoryIds: [String]) async {
        // 1. Fetch old products and delete them
        // 2. Add new products
        guard let predicate = makeSearchPredicateForCategories(categoryIds: categoryIds) else {
            return
        }
        let old = await productsStore.getList(predicate: predicate)
        let _store = productsStore
        await _store.bulkWrite(operations: [
            {await _store.delete(old)},
            {await _store.addOrUpdate(products)},
        ])
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
