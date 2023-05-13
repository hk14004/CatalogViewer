//
//  DependencyProvider.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 11/05/2023.
//

import Foundation
import Swinject

let DI = DependencyProvider()

class DependencyProvider {

    let container = Container()
    let assembler: Assembler

    init() {
        assembler = Assembler(
            [
                DataMapperAssembly(),
                DataProviderAssambly(),
                PersistentCoreDataStoreAssembly(),
                PersistentRealmStoreAssembly(),
                RepositoryAssembly(),
            ],
            container: container
        )
    }
}
