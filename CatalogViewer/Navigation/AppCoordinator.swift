//
//  AppCoordinator.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 24/03/2023.
//

import UIKit
import DevToolsNavigation

class AppCoordinator: NavigationCoordinator {
    
    // MARK: Properties
    
    private let window: UIWindow
    
    // Coordinator
    var onFree: FreeCoodinatorClosure = {}
    var router: RouterProtocol
    var children: [NavigationCoordinator] = []
    
    func start() {
        router.navigationController.navigationBar.isHidden = true
        goToInitialScreen()
        window.rootViewController = router.navigationController
    }
    
    init(window: UIWindow) {
        self.window = window
        router = Router(navigationController: .init())
    }
}

// MARK: Private

extension AppCoordinator {
    private func goToInitialScreen() {
        goToCategoriesList()
    }
    
    private func goToCategoriesList() {
        let coordinator = CategoriesCoordinator(router: router)
        store(coordinator: coordinator)
        coordinator.start()
    }
}
