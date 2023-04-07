//
//  Category.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import Foundation

public struct Category {
    public let id: String
    let parentID: String
    let imageURL: String
    let size: String
    let title: String
}

extension Category: Equatable {}
extension Category: Hashable {}
