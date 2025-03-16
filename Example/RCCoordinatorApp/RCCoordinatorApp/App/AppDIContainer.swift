//
//  AppDIContainer.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import Factory
import UIKit

final class AppDIContainer: BaseDIContainer {
    static let shared = AppDIContainer()
    let manager = ContainerManager()

    private init() { }

    var appCoordinator: Factory<any AppCoordinator> {
        self {
            AppCoordinatorImpl(
                window: self.common.appWindow(),
                navigationController: self.common.appNavigationController(),
                appManager: self.common.appManager()
            )
        }
        .scope(.singleton)
    }

    // MARK: - SPLASH

    var splashViewController: Factory<DummyViewController> {
        self {
            MainActor.assumeIsolated {
                let viewModel = DummyViewModel(
                    pageTitle: "SPLASH SCREEN",
                    buttons: []
                )
                let viewController = DummyViewController(
                    rootView: .init(viewModel: viewModel),
                    coordinator: self.appCoordinator()
                )
                return viewController
            }
        }
        .scope(.shared)
    }

    // MARK: ONBOARDING

    

}
