//
//  CatalogRepository.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation
import Combine
import DevToolsCore

protocol CategoryRepository {
    
    // Remote data
    func refreshCategories() async
    
    // Local data
    func observeCategories() -> AnyPublisher<[Category], Never>
    func getCategories() async -> [Category]
    func getCategoryPage(pageOptions: PagedRequestOptions) async -> PagedResult<Category>

}
