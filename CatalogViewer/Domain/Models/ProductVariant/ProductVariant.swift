//
//  Variant.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 30/03/2023.
//

import Foundation
import DevToolsCore

public struct ProductVariant {
    public let id: String
    let productId: String
    let name: String
    let size: String
    let color: String
    let colorCode: String
    let colorCode2: String
    let image: String
    let price: Money
    let inStock: Bool
}

extension ProductVariant: Equatable {}
extension ProductVariant: Hashable {}
