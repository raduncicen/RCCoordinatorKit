//
//  TabbarDIContainer.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//


import Factory
import UIKit

final class TabbarDIContainer: BaseDIContainer {
    static let shared = TabbarDIContainer()
    let manager = ContainerManager()

    private init() { }

    var tabbarCoordinator: Factory<any TabbarCoordinator> {
        self {
            TabbarCoordinatorImpl(navigationController: self.common.appNavigationController())
        }
        .scope(.shared)
    }

    var tabbarViewModel: Factory<TabbarViewModel> {
        self {
            TabbarViewModel(coordinator: self.tabbarCoordinator())
        }
        .scope(.shared)
    }

    var tabbarViewController:  ParameterFactory<(() -> [UIViewController]?), TabbarViewController> {
        self {
            TabbarViewController(
                viewModel: self.tabbarViewModel(),
                makeViewControllersFactory: $0
            )
        }
        .scope(.shared)
    }

}
