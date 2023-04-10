//
//  Category + PersistableDomainModelProtocol.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import DevToolsCore
import CoreData

extension Category: PersistableDomainModelProtocol {
    public typealias StoreType = Category_CD
}
