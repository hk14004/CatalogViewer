//
//  Dependencies + CoreData.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 07/04/2023.
//

import Swinject
import CoreData
import RealmSwift
import DevToolsRealm
import DevTools

let DI_REALM: (Container)->() = { container in
    
    container.register(Realm.Configuration.self) { resolver in
        Realm.Configuration()
    }
    container.register(BasePersistedLayerInterface<Category>.self) { resolver in
        PersistentRealmStore<Category>(dbConfig: resolver.resolve(Realm.Configuration.self)!)
    }
    container.register(BasePersistedLayerInterface<Product>.self) { resolver in
        PersistentRealmStore<Product>(dbConfig: resolver.resolve(Realm.Configuration.self)!)
    }
    container.register(BasePersistedLayerInterface<ProductVariant>.self) { resolver in
        PersistentRealmStore<ProductVariant>(dbConfig: resolver.resolve(Realm.Configuration.self)!)
    }
    
}
