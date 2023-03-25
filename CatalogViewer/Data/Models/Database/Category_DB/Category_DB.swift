//
//  Category_DB.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import DevToolsRealm
import RealmSwift

class Category_DB: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var parentID: String
    @Persisted var imageURL: String
    @Persisted var size: String
    @Persisted var title: String
    
}
