//
//  Category + PersistableDomainModelProtocol.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import DevTools

extension Category: PersistableDomainModelProtocol {
    typealias StoreType = Category_DB
}
