//
//  Product_DB.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import DevToolsRealm
import RealmSwift

public class Product_DB: Object {
    
    @Persisted(primaryKey: true) public var id: String
    @Persisted var mainCategoryID: String
    @Persisted var type: String
    @Persisted var typeName: String
    @Persisted var title: String
    @Persisted var brand: String
    @Persisted var model: String
    @Persisted var image: String
    @Persisted var variantCount: Int
    @Persisted var currencyID: String
    
}
