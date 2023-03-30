//
//  Product + PersistableDomainModelProtocol.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import DevTools

extension ProductVariant: PersistableDomainModelProtocol {
    typealias StoreType = ProductVariant_DB
}
