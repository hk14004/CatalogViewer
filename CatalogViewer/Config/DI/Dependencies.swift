//
//  Dependencies.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import Swinject
import Moya
import DevToolsNetworking
import DevToolsCore

let DI: Container = {
    let container = Container()
    
    // MARK: Data
    
    DI_CORE_DATA(container)
//    DI_REALM(container)

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
                           categoriesStore:  resolver.resolve(BasePersistedLayerInterface<Category>.self)!,
                           mapper: resolver.resolve(CategoryResponseMapperProtocol.self)!)
    }
    container.register(ProductRepositoryProtocol.self) { resolver in
        ProductRepository(remoteProvider: resolver.resolve(CatalogProviderProtocol.self)!,
                          productsStore: resolver.resolve(BasePersistedLayerInterface<Product>.self)!,
                          mapper: resolver.resolve(ProductResponseMapperProtocol.self)!,
                          productVariantStore: resolver.resolve(BasePersistedLayerInterface<ProductVariant>.self)!)
    }
    
    return container
}()
