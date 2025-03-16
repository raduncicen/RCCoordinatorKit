//
//  HomeDIContainer.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 16.03.2025.
//

import Factory
import UIKit

final class HomeDIContainer: BaseDIContainer {
    static let shared = HomeDIContainer()
    let manager = ContainerManager()

    private init() { }

    var homeCoordinator: Factory<any HomeCoordinator> {
        self {
            HomeCoordinatorImpl(navigationController: self.common.appNavigationController())
        }
        .scope(.shared)
    }

    var homeViewModel: Factory<HomeViewModel> {
        self {
            HomeViewModel(
                coordinator: self.homeCoordinator(),
                state: .init(.init())
            )
        }
        .scope(.shared)
    }

    var homeViewController: Factory<HomeViewController> {
        self {
            let viewModel = self.homeViewModel()
            let view = HomeView(viewModel: viewModel)
            return HomeViewController(
                rootView: view,
                coordinator: self.homeCoordinator()
            )
        }
        .scope(.shared)
    }

}
