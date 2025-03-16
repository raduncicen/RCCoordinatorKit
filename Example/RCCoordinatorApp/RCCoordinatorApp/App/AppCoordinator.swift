//
//  AppCoordinator.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import Combine
import SwiftUI
import RCCoordinatorKit

protocol AppCoordinatorDelegate: RCCoordinatorDelegate {}

protocol AppCoordinator: RCCoordinator {
    func start()
}

class AppCoordinatorImpl: RCBaseCoordinator<AppCoordinatorDelegate>, AppCoordinator {
    private let window: UIWindow
    private var appManager: AppManager
    private let appDIContainer: AppDIContainer = .shared
    private var cancellables: Set<AnyCancellable> = []

    init(
        window: UIWindow,
        navigationController: UINavigationController,
        appManager: AppManager
    ) {
        self.window = window
        self.appManager = appManager
        super.init(navigationController: navigationController)
    }
    
    required init(navigationController: UINavigationController) {
        fatalError("init(navigationController:) has not been implemented")
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        appManager.appStatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] appState in
                self?.handleAppState(appState)
            }.store(in: &cancellables)
    }

    func handleAppState(_ state: AppState) {
        switch state {
        case .splash:
            showSplashScreen()
        case .onboarding:
            showOnboardingScreen()
        case .login:
            showLoginScreen()
        case .loggedIn:
            showTabbarScreen()
        }
    }

    func showSplashScreen() {
        let viewController = appDIContainer.splashViewController()
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showOnboardingScreen() {
//        let viewController = appDIContainer.onboardingViewController()
//        navigationController.setViewControllers([viewController], animated: true)
    }

    func showLoginScreen() {
        self.resetChilds()
        let coordinator = LoginDIContainer.shared.loginCoordinator()
        insertChild(coordinator)
        coordinator.start(popUpTo: nil)
    }

    func showRegisterScreen() {
        let coordinator = RegisterDIContainer.shared.registerCoordinator()
        insertChild(coordinator)
        coordinator.start()
    }

    func showTabbarScreen() {
        self.resetChilds()
        let coordinator = TabbarDIContainer.shared.tabbarCoordinator()
        insertChild(coordinator)
        coordinator.start()
    }

}

extension AppCoordinatorImpl: LoginCoordinatorDelegate {
    func loginSuccessful() {
        appManager.setState(.loggedIn)
    }
}

extension AppCoordinatorImpl: TabbarCoordinatorDelegate { }
