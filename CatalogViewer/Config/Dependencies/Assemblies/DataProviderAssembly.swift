//
//  DataProviderAssembly.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 11/05/2023.
//

import Foundation
import Swinject
import Moya
import DevToolsNetworking

class DataProviderAssambly: Assembly {
    
    func assemble(container: Container) {
        container.register(MoyaProvider<CatalogTarget>.self) { resolver in
            MoyaProvider()
        }.inObjectScope(.container)
        
        container.register(RequestManager<CatalogTarget>.self) { resolver in
            RequestManager()
        }.inObjectScope(.container)
        
        container.register(CatalogProvider.self) { resolver in
            CatalogProviderImpl(provider: MoyaProvider<CatalogTarget>(),
                                requestManager: RequestManager<CatalogTarget>())
        }.inObjectScope(.container)
    }
    
}
