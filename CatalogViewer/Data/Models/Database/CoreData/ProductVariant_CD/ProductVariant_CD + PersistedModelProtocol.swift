//
//  ProductVariant_CD + PersistedModelProtocol.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import DevTools
import CoreData

typealias shit = ProductVariant_CD
extension ProductVariant_CD: PersistedModelProtocol {
        
    enum PersistedField: String, PersistedModelFieldProtocol {
        case id
        case productId
        case name
        case color
        case colorCode
        case colorCode2
        case image
        case price
        case inStock
    }

    func toDomain(fields: Set<PersistedField>) throws -> ProductVariant {
        return .init(id: self.id, productId: self.productId, name: self.name, size: self.size, color: self.color, colorCode: self.colorCode, colorCode2: self.colorCode2, image: self.image, price: self.price, inStock: self.inStock)
    }

    func update(with model: ProductVariant, fields: Set<PersistedField>) {
        // TODO: Handle fields if needed
        self.id = model.id
        self.productId = model.productId
        self.name = model.name
        self.color = model.color
        self.colorCode = model.colorCode
        self.colorCode2 = model.colorCode2
        self.image = model.image
        self.price = model.price
        self.inStock = model.inStock
    }
}
