//
//  Product + PersistableDomainModelProtocol.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import DevToolsCore
import CoreData

extension ProductVariant: PersistableDomainModelProtocol {
    public typealias StoreType = ProductVariant_CD
}
