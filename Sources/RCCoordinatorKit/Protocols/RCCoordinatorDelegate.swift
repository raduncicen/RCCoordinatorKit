//
//  RCNavigationDelegate.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 25.02.2025.
//

public protocol RCCoordinatorDelegate: AnyObject {
    func removeChildCoordinator(with identifier: String?)
    func removeChildCoordinatorForSwipeDismiss(with identifier: String?)
}


extension RCCoordinatorDelegate {
    func removeChildCoordinator(with identifier: String?) {
        guard let parent = self as? (any RCCoordinator) else {
            assertionFailure("NavDelegate can only be assigned to an RCCoordinator")
            return
        }
        parent.removeChild(id: identifier)
    }

    /// This function is for `RCHostingController` and should only be called from there when a dismiss action occurs through an interactive swipe gesture or default navigation back bar button.
    func removeChildCoordinatorForSwipeDismiss(with identifier: String?) {
        guard let parent = self as? (any RCCoordinator) else {
            assertionFailure("NavDelegate can only be assigned to an RCCoordinator")
            return
        }
        parent.removeChild(id: identifier)
    }
}


