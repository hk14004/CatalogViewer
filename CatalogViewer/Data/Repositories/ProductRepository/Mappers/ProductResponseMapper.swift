//
//  ProductResponseMapper.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation

protocol ProductResponseMapperProtocol {
    func map(response: ProductsResponse) -> [Product]
}

class ProductResponseMapper {
    
}

extension ProductResponseMapper: ProductResponseMapperProtocol {
    func map(response: ProductsResponse) -> [Product] {
        let items: [Product] = response.result.map { item in
            Product(id: "\(item.id ?? -666)", mainCategoryID: "\(item.main_category_id ?? -666)",
                    type: item.type ?? "", typeName: item.type_name ?? "", title: item.title ?? "",
                    brand: item.brand ?? "", model: item.model ?? "", image: item.image ?? "",
                    variantCount: 0, currencyID: item.currency ?? "")
        }
        
        return items
    }
}
