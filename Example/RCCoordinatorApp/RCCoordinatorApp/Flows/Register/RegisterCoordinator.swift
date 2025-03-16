//
//  RegisterCoordinator.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import RCCoordinatorKit
import SwiftUI

protocol RegisterCoordinatorDelegate: RCCoordinatorDelegate {}

protocol RegisterCoordinator: RCCoordinator {
    func start()
    func showRegisterStep2()
    func showRegisterStep3()
    func showRegisterSuccess()
}

class RegisterCoordinatorImpl: RCBaseCoordinator<RegisterCoordinatorDelegate>, RegisterCoordinator {

    let registerDIContainer: RegisterDIContainer = .shared

    func start() {
        let viewController = registerDIContainer.registerViewController()
        presentAsRoot(viewController)
    }

    func showRegisterStep2() {
        let viewController = registerDIContainer.dummyViewController(
            (
                pageTitle: "Register Step2",
                buttons: [
                    .init(title: "Next", onTap: showRegisterStep3),
                    .init(title: "Go back", onTap: { [weak self] in
                        self?.navigationController.popViewController(animated: true)
                    })
                ]
            )
        )

        navigationController.pushViewController(viewController, animated: true)
    }

    func showRegisterStep3() {
        let viewController = registerDIContainer.dummyViewController(
            (
                pageTitle: "Register Step3",
                buttons: [
                    .init(title: "Next", onTap: showRegisterSuccess),
                    .init(title: "Go back", onTap: { [weak self] in
                        self?.navigationController.popViewController(animated: true)
                    })
                ]
            )
        )

        navigationController.pushViewController(viewController, animated: true)
    }

    func showRegisterSuccess() {
        let viewController = registerDIContainer.dummyViewController(
            (
                pageTitle: "Register Success",
                buttons: [
                    .init(title: "Dismiss", onTap: { [weak self] in
                        self?.navigationController.popViewController(animated: true)
                    }),
                ]
            )
        )

        presentAsRoot(viewController)
    }
}
