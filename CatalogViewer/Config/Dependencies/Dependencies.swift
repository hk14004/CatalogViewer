//
//  Dependencies.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import Swinject
import RealmSwift
import DevToolsRealm
import Moya
import DevToolsNetworking
import UIKit

let DI: Container = {
    let container = Container()
    
    // MARK: Data
    
    // Stores
    container.register(DispatchQueue.self,
                       name: DATABASE_QUEUE_NAME) { _ in DispatchQueue(label: DATABASE_QUEUE_NAME) }
    container.register(Realm.self) { resolver in
        let queue = resolver.resolve(DispatchQueue.self, name: DATABASE_QUEUE_NAME)!
        func makeRealm() -> Realm {
            var realm: Realm? = nil
            queue.sync {
                let r = try! Realm()
                realm = r
            }
            return realm!
        }
        return makeRealm()
    }
    container.register(PersistentRealmStore<Category>.self) { resolver in
        PersistentRealmStore(realm: resolver.resolve(Realm.self)!)
    }
    container.register(PersistentRealmStore<Product>.self) { resolver in
        PersistentRealmStore(realm: resolver.resolve(Realm.self)!)
    }
    
    // Providers
    container.register(CatalogProviderProtocol.self) { resolver in
        CatalogProvider(provider: MoyaProvider<CatalogTarget>(),
                        requestManager: RequestManager<CatalogTarget>())
    }
    
    // Data mappers
    container.register(ProductResponseMapperProtocol.self) { resolver in
        ProductResponseMapper()
    }
    
    // Repositories
    container.register(CategoryRepositoryProtocol.self) { resolver in
        CategoryRepository(remoteProvider: resolver.resolve(CatalogProviderProtocol.self)!,
                           categoriesStore:  resolver.resolve(PersistentRealmStore<Category>.self)!)
    }
    container.register(ProductRepositoryProtocol.self) { resolver in
        ProductRepository(remoteProvider: resolver.resolve(CatalogProviderProtocol.self)!,
                          store: resolver.resolve(PersistentRealmStore<Product>.self)!,
                          mapper: resolver.resolve(ProductResponseMapperProtocol.self)!)
    }
    
    return container
}()
