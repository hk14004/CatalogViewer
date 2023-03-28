//
//  CatalogService.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import DevToolsNetworking
import Moya

protocol CatalogProviderProtocol {
    func getRemoteCategories(completion: @escaping (Result<CategoriesResponse, CatalogProviderError>)->())
    func getRemoteProducts(categoryIds: [String], completion: @escaping (Result<ProductsResponse, CatalogProviderError>)->())
}


class CatalogProvider {
    
    // MARK: Properties
    
    // Private
    private let provider: MoyaProvider<CatalogTarget>
    private let requestManager: RequestManager<CatalogTarget>

    
    // MARK: Init
    
    init(provider: MoyaProvider<CatalogTarget>, requestManager: RequestManager<CatalogTarget>) {
        self.provider = provider
        self.requestManager = requestManager
    }
    
}

// MARK: CatalogProviderProtocol

extension CatalogProvider: CatalogProviderProtocol {
    func getRemoteProducts(categoryIds: [String], completion: @escaping (Result<ProductsResponse, CatalogProviderError>) -> ()) {
        guard !categoryIds.isEmpty else {
            completion(.failure(.userError(description: "Provide category id")))
            return
        }
        let ids: String = categoryIds.joined(separator: ",")
        let target = CatalogTarget(endpoint: .getProducts, urlParameters: [CatalogProviderField.category_id.rawValue: ids])
        let launched = requestManager.launchSingleUniqueRequest(requestID: target.defaultUUID, target: target, provider: provider,
                                                                hookRunning: true, retryMethod: .default) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try JSONDecoder().decode(ProductsResponse.self, from: response.data)
                    completion(.success(response))
                } catch (let decodeError) {
                    print(decodeError)
                    completion(.failure(.responseDecodeIssue))
                }
            case .failure(let err):
                completion(.failure(.fetchFailed(code: err.errorCode)))
            }
        }
        
        if !launched {
            completion(.failure(CatalogProviderError.alreadyRunning))
        }
    }
    
    func getRemoteCategories(completion: @escaping (Result<CategoriesResponse, CatalogProviderError>) -> ()) {
        let target = CatalogTarget(endpoint: .getCategories)
        let launched = requestManager.launchSingleUniqueRequest(requestID: target.defaultUUID, target: target, provider: provider,
                                                                hookRunning: true, retryMethod: .default) { result in
            DispatchQueue.global().async {
                switch result {
                case .success(let response):
                    do {
                        let response = try JSONDecoder().decode(CategoriesResponse.self, from: response.data)
                        completion(.success(response))
                    } catch (let decodeError) {
                        print(decodeError)
                        completion(.failure(.responseDecodeIssue))
                    }
                case .failure(let err):
                    completion(.failure(.fetchFailed(code: err.errorCode)))
                }
            }
        }
        
        if !launched {
            completion(.failure(CatalogProviderError.alreadyRunning))
        }
    }
}
