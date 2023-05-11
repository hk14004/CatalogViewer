//
//  CatalogService.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import DevToolsNetworking
import Moya

// TODO: Convert to async
protocol CatalogProvider {
    func getRemoteCategories(completion: @escaping (Result<CategoriesResponse, CatalogProviderError>)->())
    func getRemoteProducts(categoryIds: [String],
                           completion: @escaping (Result<ProductsResponse, CatalogProviderError>)->())
    func getRemoteProductDetails(productID: String,
                                 completion: @escaping (Result<ProductDetailsResponse, CatalogProviderError>)->())
}

enum CatalogProviderError: Swift.Error {
    
    case alreadyRunning
    case responseDecodeIssue
    case fetchFailed(code: Int)
    case userError(description: String)
    
}

enum CatalogProviderField: String {
    case category_id
}
