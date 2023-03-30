//
//  ProductsResponse.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation

struct ProductDetailsResponse: Codable {
    let code: Int
    let result: Result
}

extension ProductDetailsResponse {
    struct Result: Codable {
        let product: ProductsResponse.DecodedProduct
        let variants: [DecodedVariant]
    }
    
    struct DecodedVariant: Codable {
        let id: Int
        let product_id: Int
        let name: String
        let size: String
        let color: String
        let color_code: String
        let color_code2: String
        let image: String
        let price: Double
        let in_stock: Bool
    }
}
