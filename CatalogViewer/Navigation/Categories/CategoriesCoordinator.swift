//
//  CategoriesCoordinator.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import SwiftUI
import DevToolsNavigation

class CategoriesCoordinator: NavigationCoordinator {
    
    var onFree: FreeCoodinatorClosure = {}
    var router: RouterProtocol
    var children: [NavigationCoordinator] = []
    
    func start() {
        let vm = CategoriesScreenVM(categoryRepository: DI.resolve(CategoryRepositoryProtocol.self)!)
        vm.navigationDelegate = self
        let vc = UIHostingController(rootView: CategoriesScreenView(viewModel: vm))
        router.push(vc, isAnimated: true, onNavigateBack: onFree)
    }
    
    init(router: RouterProtocol) {
        self.router = router
    }
}

// MARK: CategoriesScreenVMNavigationDelegate

extension CategoriesCoordinator: CategoriesScreenVMNavigationDelegate {
    func categoriesScreenVM(vm: CategoriesScreenVM, didSelectCategory category: Category) {
        goToCategory(item: category)
    }
}

// MARK: CategoriesScreenVMNavigationDelegate

extension CategoriesCoordinator: CategoryProductsScreenVMNavigationDelegate {
    func categoryProductsScreenVM(vm: CategoryProductsScreenVM, showProductDetails product: Product) {
        goToProductDetails(item: product)
    }
}

// MARK: Private

extension CategoriesCoordinator {
    private func goToCategory(item: Category) {
        let vm = CategoryProductsScreenVM(category: item,
                                          productsRepository: DI.resolve(ProductRepositoryProtocol.self)!)
        vm.navigationDelegate = self
        let vc = UIHostingController(rootView: CategoryProductsScreenView(viewModel: vm))
        vc.title = item.title
        router.navigationController.pushViewController(vc, animated: true)
    }
    
    private func goToProductDetails(item: Product) {
        let vm = ProductScreenVM(product: item,
                                 productsRepository: DI.resolve(ProductRepositoryProtocol.self)!)
        let vc = UIHostingController(rootView: ProductScreenView(viewModel: vm))
        router.navigationController.pushViewController(vc, animated: true)
    }
}
