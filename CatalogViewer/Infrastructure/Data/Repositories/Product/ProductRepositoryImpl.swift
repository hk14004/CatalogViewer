//
//  ProductRepository.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 12/05/2023.
//

import Foundation
import Combine
import DevToolsCore

class ProductRepositoryImpl {
    
    // MARK: Properties
    
    private let remoteProvider: CatalogProvider
    private let productsStore: BasePersistedLayerInterface<Product>
    private let mapper: ProductResponseMapper
    private let productVariantStore: BasePersistedLayerInterface<ProductVariant>
    
    // MARK: Init
    
    init(remoteProvider: CatalogProvider,
         productsStore: BasePersistedLayerInterface<Product>,
         mapper: ProductResponseMapper,
         productVariantStore: BasePersistedLayerInterface<ProductVariant>) {
        self.remoteProvider = remoteProvider
        self.productsStore = productsStore
        self.mapper = mapper
        self.productVariantStore = productVariantStore
    }
    
}

extension ProductRepositoryImpl: ProductRepository {
    func addOrUpdate(product: Product) async {
        await productsStore.addOrUpdate([product])
    }
    
    func deleteProducts(ids: [String]) async {
        await productsStore.delete(ids)
    }
    
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
        let sort: [NSSortDescriptor] = [.init(key: Product_CD.PersistedField.title.rawValue,
                                              ascending: true)]
        return await productsStore.getList(predicate: predcate, sortDescriptors: sort)
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
        let sort: [NSSortDescriptor] = [.init(key: Product_CD.PersistedField.title.rawValue,
                                              ascending: true)]
        return productsStore.observeList(predicate: predcate, sortDescriptors: sort)
    }
    
}

// MARK: Private

extension ProductRepositoryImpl {
    
    private func replaceProductVariants(withVariants variants: [ProductVariant], forProduct productID: String) async {
        // 1. Fetch old variants and delete them
        // 2. Add new variants
        let predicate = NSPredicate(format: "\(ProductVariant_CD.PersistedField.productId) == '\(productID)'")
        let old = await productVariantStore.getList(predicate: predicate).map({$0.id})
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
        let old = await productsStore.getList(predicate: predicate).map({$0.id})
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
            NSPredicate(format: "\(Product_CD.PersistedField.mainCategoryID) == '\(categoryID)'")
        }
        
        let compound = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        return compound
    }
    
}
