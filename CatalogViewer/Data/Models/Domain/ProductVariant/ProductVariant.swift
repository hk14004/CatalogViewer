//
//  Variant.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 30/03/2023.
//

import Foundation

struct ProductVariant {
    let id: String
    let productId: String
    let name: String
    let size: String
    let color: String
    let colorCode: String
    let colorCode2: String
    let image: String
    let price: Double
    let inStock: Bool
}

extension ProductVariant: Equatable {}
extension ProductVariant: Hashable {}
