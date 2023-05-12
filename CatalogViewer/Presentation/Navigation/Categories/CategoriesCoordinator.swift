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
        let vm = CategoriesScreenVMImpl(categoryRepository: DI.container.resolve(CategoryRepository.self)!)
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
    func categoriesScreenVM(vm: any CategoriesScreenVM, didSelectCategory category: Category) {
        goToCategory(item: category)
    }
}

// MARK: CategoriesScreenVMNavigationDelegate

extension CategoriesCoordinator: CategoryProductsScreenVMNavigationDelegate {
    func categoryProductsScreenVM(vm: any CategoryProductsScreenVM, showProductDetails product: Product) {
        goToProductDetails(item: product)
    }
}

// MARK: Private

extension CategoriesCoordinator {
    private func goToCategory(item: Category) {
        let vm = CategoryProductsScreenVMImpl(category: item,
                                          productsRepository: DI.container.resolve(ProductRepository.self)!)
        vm.navigationDelegate = self
        let vc = UIHostingController(rootView: CategoryProductsScreenView(viewModel: vm))
        vc.title = item.title
        router.navigationController.pushViewController(vc, animated: true)
    }
    
    private func goToProductDetails(item: Product) {
        let vm = ProductScreenVMImpl(product: item,
                                 productsRepository: DI.container.resolve(ProductRepository.self)!)
        let vc = UIHostingController(rootView: ProductScreenView(viewModel: vm))
        router.navigationController.pushViewController(vc, animated: true)
    }
}
