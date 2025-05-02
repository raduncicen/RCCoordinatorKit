//
//  RCCoordinator.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 25.02.2025.
//

import SwiftUI


public enum RCCoordinatorRootPresentationStyle: Equatable {
    /// Pushes the given `viewController` to the `navigationController`.of the coordinator
    case push
    /// Embeds the given viewController inside a new NavigationController (a,k,a embeddedNavigationController inside the the `RCCoordinator`) and pushes that navigation controller to the navigationStack.
    case pushInsideEmbeddedNavigationController
    /// Embeds the given viewController inside a new NavigationController and presents the `embeddedNavigationController` on top of `navigationController` of `RCCoordinator`
    case present(_ presentationOptions: PresentationOptions)


    public struct PresentationOptions: Equatable {
        var modalPresentationStyle: UIModalPresentationStyle = .pageSheet
        var enableInteractiveDismiss: Bool = true
    }
}

public protocol RCCoordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var embeddedNavigationController: UINavigationController? { get set }

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

        if let embeddedNavigationController {
            guard embeddedNavigationController.identifier == identifier else {
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
    internal func presentAsRootLogic(
        _ viewController: RCViewControllerProtocol,
        style: RCCoordinatorRootPresentationStyle = .push,
        popUpTo identifier: String? = nil,
        animated: Bool = true
    ) {
        switch style {
        case .push, .pushInsideEmbeddedNavigationController:
            var viewController = (style == .pushInsideEmbeddedNavigationController)
            ? embedRootInsideANavigationController(viewController: viewController)
            : viewController

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
            else {
                matchCoordinatorIdWithRootViewController(viewController)
                navigationController.pushViewController(viewController, animated: animated)
            }

        case .present(let presentationOptions):
            if let embeddedNavigationController, embeddedNavigationController.identifier == identifier {
                embeddedNavigationController.setViewControllers([viewController], animated: animated)
            } else {
                let embeddedNavigationController = embedRootInsideANavigationController(viewController: viewController)
                matchCoordinatorIdWithRootViewController(embeddedNavigationController)
                embeddedNavigationController.modalPresentationStyle = presentationOptions.modalPresentationStyle
                embeddedNavigationController.isModalInPresentation = !presentationOptions.enableInteractiveDismiss

                let viewControllerToPresentOn = topViewController(of: navigationController) ?? navigationController
                viewControllerToPresentOn.present(embeddedNavigationController, animated: animated)
            }
        }
    }

    private func embedRootInsideANavigationController(viewController: RCViewControllerProtocol) -> RCViewControllerProtocol {
        let embeddedNavigationController = RCEmbeddedNavigationController(rootViewController: viewController, coordinator: self)
        self.embeddedNavigationController = embeddedNavigationController
        return embeddedNavigationController
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

// MARK: - TOOLS

extension RCCoordinator {

    public func topViewController(of viewController: UIViewController? = nil) -> UIViewController? {
        guard let viewController else { return nil }

        if let nav = viewController as? UINavigationController {
            return topViewController(of: nav.visibleViewController)
        }

        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(of: selected)
            }
        }

        if let presented = viewController.presentedViewController {
            return topViewController(of: presented)
        }

        // Handle Split View Controller
        if let split = viewController as? UISplitViewController {
            if UIDevice.current.userInterfaceIdiom == .pad {
                // iPad için detay viewController'ı döndür
                if let detailNav = split.viewControllers.last as? UINavigationController {
                    return topViewController(of: detailNav.visibleViewController)
                }
                return topViewController(of: split.viewControllers.last)
            }
            // iPhone için primary viewController'ı döndür
            if let primaryNav = split.viewControllers.first as? UINavigationController {
                return topViewController(of: primaryNav.visibleViewController)
            }
            return topViewController(of: split.viewControllers.first)
        }

        return viewController
    }
}
