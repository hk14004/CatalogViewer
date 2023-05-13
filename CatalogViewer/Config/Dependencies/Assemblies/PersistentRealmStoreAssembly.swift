//
//  PersistentRealmStoreAssembly.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 11/05/2023.
//

import Foundation

import Swinject
import DevToolsCore
import DevToolsRealm
import RealmSwift

// Optionaly run realm
class PersistentRealmStoreAssembly: Assembly {

    func assemble(container: Container) {
        // MARK: Realm stack

        container.register(Realm.Configuration.self) { resolver in
            Realm.Configuration()
        }

        // MARK: Entities

//        container.register(BasePersistedLayerInterface<Category>.self) { resolver in
//            PersistentRealmStore<Category>(dbConfig: resolver.resolve(Realm.Configuration.self)!)
//        }
//        container.register(BasePersistedLayerInterface<Product>.self) { resolver in
//            PersistentRealmStore<Product>(dbConfig: resolver.resolve(Realm.Configuration.self)!)
//        }
//        container.register(BasePersistedLayerInterface<ProductVariant>.self) { resolver in
//            PersistentRealmStore<ProductVariant>(dbConfig: resolver.resolve(Realm.Configuration.self)!)
//        }
    }
    
}
