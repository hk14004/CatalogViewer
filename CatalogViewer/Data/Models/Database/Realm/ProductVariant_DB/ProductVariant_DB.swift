//
//  ProductVariant_DB.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import DevToolsRealm
import RealmSwift

class ProductVariant_DB: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var productId: String
    @Persisted var name: String
    @Persisted var size: String
    @Persisted var color: String
    @Persisted var colorCode: String
    @Persisted var colorCode2: String
    @Persisted var image: String
    @Persisted var price: Double
    @Persisted var inStock: Bool
    
}
