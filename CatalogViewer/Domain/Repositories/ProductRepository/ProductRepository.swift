//
//  ProductRepository.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import Combine
import DevToolsCore

protocol ProductRepository {
    
    // Remote data
    func refreshProducts(categoryIds: [String]) async
    func refreshProductDetails(productID: String) async
    
    // Local data
    func observeProducts(categoryIds: [String]) -> AnyPublisher<[Product], Never>
    func getProducts(categoryIds: [String]) async -> [Product]
    func observeProduct(id: String) -> AnyPublisher<Product?, Never>
    func deleteProducts(ids: [String]) async
    func addOrUpdate(product: Product) async
}
