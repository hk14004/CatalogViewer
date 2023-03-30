//
//  ProductResponseMapper.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//

import Foundation

protocol ProductResponseMapperProtocol {
    func map(response: ProductsResponse) -> [Product]
    func map(response: ProductDetailsResponse) -> [ProductVariant]
}

class ProductResponseMapper {
    
}

extension ProductResponseMapper: ProductResponseMapperProtocol {
    func map(response: ProductDetailsResponse) -> [ProductVariant] {
        // TODO: Validate variant
        let items: [ProductVariant] = response.result.variants.map { item in
            ProductVariant(id: "\(item.id)", productId: "\(item.product_id)", name: item.name,
                           size: item.size, color: item.color, colorCode: item.color_code,
                           colorCode2: item.color_code2, image: item.image, price: item.price, inStock: item.in_stock)
        }
        return items
    }
    
    func map(response: ProductsResponse) -> [Product] {
        // TODO: Validate product
        let items: [Product] = response.result.map { item in
            Product(id: "\(item.id ?? -666)", mainCategoryID: "\(item.main_category_id ?? -666)",
                    type: item.type ?? "", typeName: item.type_name ?? "", title: item.title ?? "",
                    brand: item.brand ?? "", model: item.model ?? "", image: item.image ?? "",
                    variantCount: 0, currencyID: item.currency ?? "")
        }
        
        return items
    }
}
