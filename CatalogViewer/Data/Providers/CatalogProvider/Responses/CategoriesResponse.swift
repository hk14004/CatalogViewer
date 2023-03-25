//
//  CategoriesResponse.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation

// TODO: Notify that API categories DOCS are OUTDATED!

struct CategoriesResponse: Codable {
    let code: Int
    let result: Result
    
}

extension CategoriesResponse {
    
    struct Result: Codable {
        let categories: [DecodedCategory]
    }
    
    struct DecodedCategory: Codable {
        let id: Int
        let parent_id: Int
        let image_url: String
        let size: String
        let title: String
    }
}
