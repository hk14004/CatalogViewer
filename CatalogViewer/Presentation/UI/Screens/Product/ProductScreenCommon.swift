//
//  ProductScreenCommon.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 12/05/2023.
//

import Foundation

protocol ProductScreenVM: ObservableObject {
    var product: Product { get set } // TODO: Add presentable protocol if needed
}
