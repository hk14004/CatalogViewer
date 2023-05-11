//
//  Product.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import Foundation

public struct Product {
    public let id: String
    let mainCategoryID: String
    let type: String
    let typeName: String
    let title: String
    let brand: String
    let model: String
    let image: String
    let variantCount: Int
    let currencyID: String
}

extension Product: Equatable {}
extension Product: Hashable {}

extension Product {
    class Preview {
        static func makePreview() -> Product {
            .init(id: UUID().uuidString, mainCategoryID: "preview", type: "Preview type", typeName: "preview type name",
                  title: "preview title", brand: "preview brand", model: "preview model",
                  image: "https://www.printful.com/static/images/layout/printful-logo.png",
                  variantCount: 1, currencyID: "123")
        }
    }
}
