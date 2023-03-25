//
//  CatalogProviderError.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation

enum CatalogProviderError: Swift.Error {
    
    case alreadyRunning
    case responseDecodeIssue
    case fetchFailed(code: Int)
    case userError(description: String)
    
}
