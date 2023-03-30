//
//  CatalogTarget.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import DevToolsNetworking
import Moya

struct CatalogTarget: RequestManagerTarget {
    
    enum Endpoint: String, CaseIterable {
        case getCategories
        case getProducts
        case getProductDetails
    }
    
    var endpoint: Endpoint
        
    var defaultUUID: String {
        endpoint.rawValue
    }
    
    var resourceIDs: [String]?
    
    var urlParameters: [String : Any]?
    
    var bodyParameters: [String : Any]?
    
    var headerParameter: [String : String]?
    
    var baseURL: URL {
        return URL(string: Hosts.PRINTFUL_API_HOST)!
    }
    
    var path: String {
        switch endpoint {
        case .getCategories:
            return "/categories"
        case .getProducts:
            return "/products"
        case .getProductDetails:
            return "/products/\(resourceIDs![0])"
        }
    }
    
    var method: Moya.Method {
        switch endpoint {
        case .getCategories:
            return .get
        case .getProducts:
            return .get
        case .getProductDetails:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self.method {
        case .get:
            if let urlParameters = urlParameters {
                return .requestParameters(parameters: urlParameters, encoding: URLEncoding.queryString)
            }
        default:
            if let bodyParameters = bodyParameters {
                return .requestParameters(parameters: bodyParameters, encoding: JSONEncoding.default)
            }
        }
        
        return .requestPlain
    }
    
    var headers: [String : String]?
    
}
