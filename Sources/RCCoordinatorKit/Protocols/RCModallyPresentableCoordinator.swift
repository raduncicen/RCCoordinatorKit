//
//  RCModallyPresentableCoordinator.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 25.02.2025.
//

import UIKit

// MARK: - Local NavigationController for Modally Presented Flows which requires navigation

protocol RCModallyPresentableCoordinator: RCCoordinator {
    var localNavigationController: UINavigationController? { get set }
}


extension RCModallyPresentableCoordinator {
    weak var localNavigationController: UINavigationController? {
        get {
            assertionFailure("LocalNavigationController is not supported for this coordinator.")
            return nil
        }
        set {
            assertionFailure("LocalNavigationController is not supported for this coordinator.")
        }
    }
    /// Embeds the given `viewController` inside of a new navigationController called `localNavigationCoordinator` and presents in with the given style
    /// - Warning: Do not call this function from the outside of the coordinator. This should only be called by the internal`start()` function of the coordinator.
    func startAsModalWithLocalNavigationController(viewController: UIViewController, modalPresentationStyle: UIModalPresentationStyle, animated: Bool) {
        let localNavigationController = UINavigationController(rootViewController: viewController)
        matchCoordinatorIdWithRootViewController(localNavigationController)
        self.localNavigationController = localNavigationController
        localNavigationController.modalPresentationStyle = modalPresentationStyle
        navigationController.present(localNavigationController, animated: animated)
    }
}
