//
//  LoginCoordinator.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import RCCoordinatorKit
import SwiftUI

protocol LoginCoordinatorDelegate: RCCoordinatorDelegate {
    func loginSuccessful()
}

protocol LoginCoordinator: RCCoordinator {
    func start(popUpTo identifier: String?)
    func showRegisterFlow()
    func showTabbar()
}

class LoginCoordinatorImpl: RCBaseCoordinator<LoginCoordinatorDelegate>, LoginCoordinator {

    override func start(popUpTo identifier: String? = nil) {
        let viewController = LoginDIContainer.shared.loginViewController()
        navigationController.setViewControllers([viewController], animated: true)
    }

    func showRegisterFlow() {
        let coordinator = RegisterDIContainer.shared.registerCoordinator()
        insertChild(coordinator)
        coordinator.start()
    }

    func showTabbar() {
        typedParent?.loginSuccessful()
    }
}

extension LoginCoordinatorImpl: RegisterCoordinatorDelegate {}
