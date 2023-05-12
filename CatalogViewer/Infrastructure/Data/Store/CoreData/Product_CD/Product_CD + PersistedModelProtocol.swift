//
//  Category_DB + PersistedModelProtocol.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import DevToolsCore
import CoreData

extension Product_CD: PersistedModelProtocol {

    public enum PersistedField: String, PersistedModelFieldProtocol {
        case mainCategoryID
        case type
        case typeName
        case title
        case brand
        case model
        case image
        case variantCount
        case currencyID
    }

    public func toDomain(fields: Set<PersistedField>) throws -> Product {
        // TODO: Throw errors etc
        return .init(id: self.id ?? "", mainCategoryID: self.mainCategoryID ?? "", type: self.type ?? "",
                     typeName: self.typeName ?? "", title: self.title ?? "", brand: self.brand ?? "",
                     model: self.model ?? "", image: self.image ?? "", variantCount: Int(self.variantCount),
                     currencyID: self.currencyID ?? "")
    }

    public func update(with model: Product, fields: Set<PersistedField>) {
        // TODO: Handle fields if needed
        self.id = model.id
        self.mainCategoryID = model.mainCategoryID
        self.type = model.type
        self.typeName = model.typeName
        self.title = model.title
        self.brand = model.brand
        self.model = model.model
        self.image = model.image
        self.variantCount = Int16(model.variantCount)
        self.currencyID = model.currencyID
    }
}

extension Product: PersistableDomainModelProtocol {
    public typealias StoreType = Product_CD
}
