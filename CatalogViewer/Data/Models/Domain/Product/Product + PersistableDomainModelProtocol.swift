//
//  Product + PersistableDomainModelProtocol.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import DevTools
import CoreData

extension Product: PersistableDomainModelProtocol {
    public typealias StoreType = Product_DB
}
