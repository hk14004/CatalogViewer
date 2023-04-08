//
//  Category_DB.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import DevToolsRealm
import RealmSwift

public class Category_DB: Object {
    
    @Persisted(primaryKey: true) public var id: String
    @Persisted var parentID: String
    @Persisted var imageURL: String
    @Persisted var size: String
    @Persisted var title: String
    
}
