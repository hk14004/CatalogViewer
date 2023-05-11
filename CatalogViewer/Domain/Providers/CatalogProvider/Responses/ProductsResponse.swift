//
//  ProductsResponse.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation

struct ProductsResponse: Codable {
    let code: Int?
    let result: [DecodedProduct]?
}

extension ProductsResponse {
    struct DecodedProduct: Codable {
        let id: Int?
        let main_category_id: Int?
        let type: String?
        let type_name: String?
        let title: String?
        let brand: String?
        let model: String?
        let image: String?
        let variant_count: Int?
        let currency: String?
        let is_discontinued: Bool?
        let description: String?
    }
}
