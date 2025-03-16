//
//  RegisterDIContainer.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import Factory
import UIKit

final class RegisterDIContainer: BaseDIContainer {
    static let shared = RegisterDIContainer()
    let manager = ContainerManager()

    private init() { }

    var registerCoordinator: Factory<any RegisterCoordinator> {
        self {
            RegisterCoordinatorImpl(navigationController: self.common.appNavigationController())
        }
        .scope(.shared)
    }

    var registerViewModel: Factory<RegisterViewModel> {
        self {
            RegisterViewModel(
                coordinator: self.registerCoordinator(),
                state: .init(.init())
            )
        }
        .scope(.shared)
    }

    var registerViewController: Factory<RegisterViewController> {
        self {
            let viewModel = self.registerViewModel()
            let view = RegisterView(viewModel: viewModel)
            return RegisterViewController(
                rootView: view,
                coordinator: self.registerCoordinator()
            )
        }
        .scope(.shared)
    }

    // MARK: Dummy View

    var dummyViewController: ParameterFactory<(pageTitle: String, buttons: [DummyButton]), DummyViewController> {
        self {
            let viewModel = DummyViewModel(
                pageTitle: $0.pageTitle,
                buttons: $0.buttons
            )
            let viewController = DummyViewController(
                rootView: .init(viewModel: viewModel),
                coordinator: self.registerCoordinator()
            )
            return viewController
        }
        .scope(.unique)
    }

}
