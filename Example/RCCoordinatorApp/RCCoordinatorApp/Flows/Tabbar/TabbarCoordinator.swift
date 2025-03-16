//
//  TabbarCoordinator.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import RCCoordinatorKit
import SwiftUI

protocol TabbarCoordinatorDelegate: RCCoordinatorDelegate {}

protocol TabbarCoordinator: RCCoordinator {
    func start()
}

class TabbarCoordinatorImpl: RCBaseCoordinator<TabbarCoordinatorDelegate>, TabbarCoordinator {

    private weak var tabbarController: TabbarViewController?

    func start() {
        let tabbarController = createTabbarViewController(())
        self.tabbarController = tabbarController
        changeTab(index: 0)
        navigationController.setViewControllers([tabbarController], animated: true)
    }

    func createTabbarViewController<T>(_ parameter: T) -> TabbarViewController {
        let makeViewControllersFactory: () -> ([UIViewController]?) = { [weak self] in
            guard let self else { return [] }

            // Create Coordinators
            let homeCoordinator = HomeDIContainer.shared.homeCoordinator()
            homeCoordinator.parent = self

            let settingsCoordinator = SettingsDIContainer.shared.settingsCoordinator()
            settingsCoordinator.parent = self

            // Insert the childCoordinators in correct order for ease of use.
            childCoordinators = [
                homeCoordinator,
                settingsCoordinator
            ]

            // Return the initial ViewController for each coordinator
            return [
                homeCoordinator.startAsTab(),
                settingsCoordinator.startAsTab()
            ]
        }

        let viewController = TabbarDIContainer.shared.tabbarViewController(makeViewControllersFactory)
        matchCoordinatorIdWithRootViewController(viewController)
        return viewController
    }

    func changeTab(index: Int) {
        tabbarController?.changeTab(index: index)
    }

}

extension TabbarCoordinatorImpl: HomeCoordinatorDelegate { }

extension TabbarCoordinatorImpl: SettingsCoordinatorDelegate { }
