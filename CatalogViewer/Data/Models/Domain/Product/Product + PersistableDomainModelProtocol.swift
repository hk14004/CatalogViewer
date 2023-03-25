//
//  Product + PersistableDomainModelProtocol.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import DevTools

extension Product: PersistableDomainModelProtocol {
    typealias StoreType = Product_DB
}
