//
//  LoginDIContainer.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import Factory
import UIKit

final class LoginDIContainer: BaseDIContainer {
    static let shared = LoginDIContainer()
    let manager = ContainerManager()

    private init() { }

    var loginCoordinator: Factory<any LoginCoordinator> {
        self {
            LoginCoordinatorImpl(navigationController: self.common.appNavigationController())
        }
        .scope(.shared)
    }

    var loginViewModel: Factory<LoginViewModel> {
        self {
            LoginViewModel(
                coordinator: self.loginCoordinator(),
                state: .init(.init())
            )
        }
        .scope(.shared)
    }

    var loginViewController: Factory<LoginViewController> {
        self {
            let viewModel = self.loginViewModel()
            let view = LoginView(viewModel: viewModel)
            return LoginViewController(
                rootView: view,
                coordinator: self.loginCoordinator()
            )
        }
        .scope(.shared)
    }

}
