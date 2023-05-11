//
//  ProductResponseMapper.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation

protocol ProductResponseMapper {
    func map(response: ProductsResponse) -> [Product]
    func map(response: ProductDetailsResponse) -> [ProductVariant]
}

class ProductResponseMapperImpl {
    
}

extension ProductResponseMapperImpl: ProductResponseMapper {
    func map(response: ProductDetailsResponse) -> [ProductVariant] {
        // TODO: Validate data
        let items: [ProductVariant] = (response.result?.variants?.map { item in
            ProductVariant(id: "\(item.id ?? 0)", productId: "\(item.product_id ?? 0)", name: item.name ?? "",
                           size: item.size ?? "", color: item.color ?? "", colorCode: item.color_code ?? "",
                           colorCode2: item.color_code2 ?? "", image: item.image ?? "", price: item.price ?? 0, inStock: item.in_stock ?? false)
        }) ?? []
        return items
    }
    
    func map(response: ProductsResponse) -> [Product] {
        // TODO: Validate data
        let items: [Product] = (response.result?.map { item in
            Product(id: "\(item.id ?? 0)", mainCategoryID: "\(item.main_category_id ?? 0)",
                    type: item.type ?? "", typeName: item.type_name ?? "", title: item.title ?? "",
                    brand: item.brand ?? "", model: item.model ?? "", image: item.image ?? "",
                    variantCount: 0, currencyID: item.currency ?? "")
        }) ?? []
        return items
    }
}
