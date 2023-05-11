//
//  CategoryResponseMapper.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 30/03/2023.
//

import Foundation

protocol CategoryResponseMapper {
    func map(response: CategoriesResponse) -> [Category]
}

class CategoryResponseMapperImpl {
    
}

extension CategoryResponseMapperImpl: CategoryResponseMapper {
    func map(response: CategoriesResponse) -> [Category] {
        // TODO: Validate data
        let items: [Category] = response.result?.categories?.map { item in
            Category(id: "\(item.id ?? 0)", parentID: "\(item.parent_id ?? 0)", imageURL: item.image_url ?? "",
                     size: item.size ?? "", title: item.title ?? "")
        } ?? []
        return items
    }
}
