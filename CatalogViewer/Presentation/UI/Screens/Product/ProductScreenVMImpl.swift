//
//  ProductScreenVM.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 30/03/2023.
//

import SwiftUI
import Combine
import DevToolsUI

class ProductScreenVMImpl: ProductScreenVM {
    
    // MARK: Types
    
    class Bag {
        var productHandle: AnyCancellable?
    }
    
    // MARK: Properties
    
    // Public
    
    // Private
    private let bag = Bag()
    private let productsRepository: ProductRepository
    @Published var product: Product // TODO: Add presentable protocol if needed
    
    // MARK: Init
    
    init(product: Product, productsRepository: ProductRepository) {
        self.product = product
        self.productsRepository = productsRepository
        startup()
    }
    
}

// MARK: Private

extension ProductScreenVMImpl {
    private func startup() {
        // TODO: Observe product details, variants. Fetch more details etc
        observeProduct()
    }
    
    private func observeProduct() {
        bag.productHandle = productsRepository.observeProduct(id: product.id)
            .dropFirst()
            .removeDuplicates()
            .sink(receiveValue: { [weak self] _product in
                guard let _product = _product else {
                    // TODO: Perhaps show message that product is no longer available and leave
                    return
                }
                self?.product = _product
        })
    }
}
