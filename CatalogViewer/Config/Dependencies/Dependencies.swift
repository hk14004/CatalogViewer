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
    container.register(Realm.Configuration.self) { resolver in
        Realm.Configuration()
    }
    container.register(PersistentRealmStore<Category>.self) { resolver in
        PersistentRealmStore<Category>(dbConfig: resolver.resolve(Realm.Configuration.self)!)
    }
    container.register(PersistentRealmStore<Product>.self) { resolver in
        PersistentRealmStore<Product>(dbConfig: resolver.resolve(Realm.Configuration.self)!)
    }
    container.register(PersistentRealmStore<ProductVariant>.self) { resolver in
        PersistentRealmStore<ProductVariant>(dbConfig: resolver.resolve(Realm.Configuration.self)!)
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
    container.register(CategoryResponseMapperProtocol.self) { resolver in
        CategoryResponseMapper()
    }
    
    // Repositories
    container.register(CategoryRepositoryProtocol.self) { resolver in
        CategoryRepository(remoteProvider: resolver.resolve(CatalogProviderProtocol.self)!,
                           categoriesStore:  resolver.resolve(PersistentRealmStore<Category>.self)!,
                           mapper: resolver.resolve(CategoryResponseMapperProtocol.self)!)
    }
    container.register(ProductRepositoryProtocol.self) { resolver in
        ProductRepository(remoteProvider: resolver.resolve(CatalogProviderProtocol.self)!,
                          productsStore: resolver.resolve(PersistentRealmStore<Product>.self)!,
                          mapper: resolver.resolve(ProductResponseMapperProtocol.self)!,
                          productVariantStore: resolver.resolve(PersistentRealmStore<ProductVariant>.self)!)
    }
    
    return container
}()
