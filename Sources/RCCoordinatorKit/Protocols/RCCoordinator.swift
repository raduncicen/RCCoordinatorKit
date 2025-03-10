//
//  RCCoordinator.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 25.02.2025.
//

import SwiftUI


public enum RCCoordinatorRootPresentationStyle {
    case push
    case present(_ modalPresentationStyle: UIModalPresentationStyle)
}

public protocol RCCoordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [RCCoordinator] { get set }
    var parent: RCCoordinatorDelegate? { get set }
    init(navigationController: UINavigationController)
}

// MARK: - NAVIGATION EXTENSIONS

public extension RCCoordinator {
    var identifier: String? {
        self.rootViewControllerIdentifier
    }

    func matchCoordinatorIdWithRootViewController(_ viewController: UIViewController) {
        let rootId = UUID().uuidString
        viewController.identifier = rootId
        rootViewControllerIdentifier = viewController.identifier
    }
}

public extension RCCoordinator {

    func presentAsRoot<Content: View>(
        _ viewController: RCHostingController<Content>,
        style: RCCoordinatorRootPresentationStyle = .push,
        popUpTo identifier: String? = nil,
        animated: Bool = true
    ) {
        // Make sure the parent is set and force it in DEV environment
        if !Helpers.isSwiftUIPreview {
            guard parent != nil else {
                assertionFailure("Coordinator must have a parent")
                return
            }
        }

        presentAsRootLogic(
            viewController,
            style: style,
            popUpTo: identifier,
            animated: animated
        )
    }

    func popFlow(animated: Bool = true) {
        guard let identifier else {
            assertionFailure("Coordinator has no assigned rootViewControllerIdentifier")
            return
        }
        // Remove this coordinator from its parent
        self.parent?.removeChildCoordinator(with: identifier)

        if let coordinator = self as? RCModallyPresentableCoordinator {
            guard coordinator.localNavigationController?.identifier == identifier else {
                assertionFailure("Coordinator's localNavigationController does not match coordinator's rootViewControllerIdentifier")
                navigationController.popViewControllers(upTo: identifier, animated: animated)
                navigationController.dismiss(animated: animated)
                return
            }
            // CASE: Has a localNavigationController as root of the coordinator
            navigationController.dismiss(animated: animated)
        } else if let presentedVC = navigationController.presentedViewController, presentedVC.identifier == identifier {
            // CASE: Has a presentedViewController (probably a success or information view) as the root of the coordinator.
            navigationController.dismiss(animated: animated)
        } else {
            // CASE: Has a default pushed root viewController as the root of the coordinator
            navigationController.popViewControllers(upTo: identifier, animated: animated)
        }
    }
}

extension RCCoordinator {
    internal func presentAsRootLogic<Content: View>(
        _ viewController: RCHostingController<Content>,
        style: RCCoordinatorRootPresentationStyle = .push,
        popUpTo identifier: String? = nil,
        animated: Bool = true
    ) {
        viewController.isCoordinatorRoot = true

        let identifier = identifier ?? self.identifier
        // If The the coordinator already has a root
        if let identifier {
            navigationController.setNavigationStack(
                upTo: identifier,
                include: true,
                adding: viewController,
                animated: animated,
                completion: nil
            )
            matchCoordinatorIdWithRootViewController(viewController)
            return
        }

        // If Coordinator just initialized
        switch style {
        case .push:
            matchCoordinatorIdWithRootViewController(viewController)
            navigationController.pushViewController(viewController, animated: animated)
        case .present(let modalPresentationStyle):
            if let coordinator = self as? RCModallyPresentableCoordinator {
                coordinator.startAsModalWithLocalNavigationController(
                    viewController: viewController,
                    modalPresentationStyle: modalPresentationStyle,
                    animated: animated
                )
                return
            }

            let embedInNavigationController = UINavigationController(rootViewController: viewController)
            matchCoordinatorIdWithRootViewController(embedInNavigationController) // FIXME: BURAYI KONTROL ETMELISIN
            navigationController.present(viewController, animated: animated)
        }
    }

}

// MARK: - CHILD COORDINATOR CRUD ACTIONS

public extension RCCoordinator {

    // MARK: - Insert and Start Child functions
    func insertChild(_ childCoordinator: RCCoordinator) {
        guard let parent = self as? RCCoordinatorDelegate else {
            assertionFailure("Coordinator should conform to respective NavDelegate for the ChildCoordinator")
            return
        }
        childCoordinator.parent = parent
        childCoordinators.append(childCoordinator)
    }

    // MARK: - Remove Child Coordinator

    @discardableResult
    func removeChild(id rootViewControllerIdentifier: String?) -> RCCoordinator? {
        guard let rootViewControllerIdentifier, let index = childCoordinators.lastIndex(where: { $0.rootViewControllerIdentifier == rootViewControllerIdentifier }) else {
            return nil
        }
        let removedChild = childCoordinators.remove(at: index)
        //        devLog("CHILD_COORDINATOR_REMOVED: Parent:\(self) - Child: \(removedChild.self)")
        return removedChild
    }

    @discardableResult
    func popLastChild() -> (any RCCoordinator)? {
        let removedChild = childCoordinators.popLast()
        //        devLog("CHILD_COORDINATOR_REMOVED: Parent:\(self) - Child: \(String(describing: removedChild.self))")
        return removedChild
    }

    func resetChilds() {
        //        devLog("CHILD_COORDINATOR_REMOVED: Parent:\(self) - Removed All Childs (Count: \(childCoordinators.count))")
        childCoordinators = []
    }
}

