//
//  DataMapperAssembly.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 11/05/2023.
//

import Foundation
import Swinject
import DevToolsCore

class DataMapperAssembly: Assembly {

    func assemble(container: Container) {
        container.register(ProductResponseMapper.self) { resolver in
            ProductResponseMapperImpl()
        }
        container.register(CategoryResponseMapper.self) { resolver in
            CategoryResponseMapperImpl()
        }
    }
    
}
