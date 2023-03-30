//
//  CategoryResponseMapper.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 30/03/2023.
//

import Foundation

protocol CategoryResponseMapperProtocol {
    func map(response: CategoriesResponse) -> [Category]
}

class CategoryResponseMapper {
    
}

extension CategoryResponseMapper: CategoryResponseMapperProtocol {
    func map(response: CategoriesResponse) -> [Category] {
        let items: [Category] = response.result.categories.map { item in
            Category(id: "\(item.id)", parentID: "\(item.parent_id)", imageURL: item.image_url, size: item.size, title: item.title)
        }
        return items
    }
}
