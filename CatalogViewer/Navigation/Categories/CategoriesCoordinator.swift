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
        let vm = CategoriesScreenVM()
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

// MARK: Private

extension CategoriesCoordinator {
    private func goToCategory(item: Category) {
        let vm = CategoryProductsScreenVM(category: item)
        let vc = UIHostingController(rootView: CategoryProductsScreenView(viewModel: vm))
        router.navigationController.pushViewController(vc, animated: true)
    }
}
