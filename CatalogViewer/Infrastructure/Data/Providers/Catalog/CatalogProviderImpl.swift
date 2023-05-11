//
//  CatalogProviderImpl.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 11/05/2023.
//

import Foundation
import DevToolsNetworking
import Moya

class CatalogProviderImpl {
    
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

extension CatalogProviderImpl: CatalogProvider {
    func getRemoteProductDetails(productID: String, completion: @escaping (Result<ProductDetailsResponse, CatalogProviderError>) -> ()) {
        let target = CatalogTarget(endpoint: .getProductDetails, resourceIDs: ["\(productID)"])
        let launched = requestManager.launchSingleUniqueRequest(requestID: target.defaultUUID, target: target, provider: provider,
                                                                hookRunning: true, retryMethod: .default) { result in
            DispatchQueue.global().async {
                let decodedResult = self.processAPIresponse(response: result, ofType: ProductDetailsResponse.self)
                completion(decodedResult)
            }
        }
        
        if !launched {
            completion(.failure(CatalogProviderError.alreadyRunning))
        }
    }
    
    func getRemoteProducts(categoryIds: [String], completion: @escaping (Result<ProductsResponse, CatalogProviderError>) -> ()) {
        guard !categoryIds.isEmpty else {
            completion(.failure(.userError(description: "Provide category id")))
            return
        }
        let ids: String = categoryIds.joined(separator: ",")
        let target = CatalogTarget(endpoint: .getProducts, urlParameters: [CatalogProviderField.category_id.rawValue: ids])
        let launched = requestManager.launchSingleUniqueRequest(requestID: target.defaultUUID, target: target, provider: provider,
                                                                hookRunning: true, retryMethod: .default) { result in
            DispatchQueue.global().async {
                let decodedResult = self.processAPIresponse(response: result, ofType: ProductsResponse.self)
                completion(decodedResult)
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
                let decodedResult = self.processAPIresponse(response: result, ofType: CategoriesResponse.self)
                completion(decodedResult)
            }
        }
        
        if !launched {
            completion(.failure(CatalogProviderError.alreadyRunning))
        }
    }
}

// MARK: Private

extension CatalogProviderImpl {
    private func processAPIresponse<DecodedResponse: Codable>(response: Result<Response, MoyaError>,
                                                              ofType: DecodedResponse.Type) -> Result<DecodedResponse, CatalogProviderError> {
        switch response {
        case .success(let response):
            do {
                let response = try JSONDecoder().decode(ofType, from: response.data)
                return .success(response)
            } catch (let decodeError) {
                print(decodeError)
                return .failure(.responseDecodeIssue)
            }
        case .failure(let err):
            return .failure(.fetchFailed(code: err.errorCode))
        }
    }
}
