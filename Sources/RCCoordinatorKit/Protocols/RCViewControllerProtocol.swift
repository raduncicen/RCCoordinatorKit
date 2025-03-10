//
//  RCViewControllerProtocol.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 25.02.2025.
//
import UIKit

public protocol RCViewControllerProtocol: AnyObject {
    var isCoordinatorRoot: Bool { get set }
    func handleSwipeDismissForCoordinator(coordinator: RCCoordinator?)
}

extension RCViewControllerProtocol where Self: UIViewController {
    public func handleSwipeDismissForCoordinator(coordinator: RCCoordinator?) {
        guard isCoordinatorRoot, let coordinator else { return }

        // Check if the view controller is being dismissed
        if self.isBeingDismissed || self.isMovingFromParent {
            if let transitionCoordinator = self.transitionCoordinator, transitionCoordinator.isInteractive {
                // Case: Interactive dismissal (e.g., swipe to dismiss).
                // Add any additional actions for an interactive dismissal
                transitionCoordinator.animate(alongsideTransition: nil) { [weak self] context in
                    if context.isCancelled {
                        // Case: Interactive dismissal was cancelled

                    } else {
                        // Case: Interactive dismissal completed
                        coordinator.parent?.removeChildCoordinatorForSwipeDismiss(with: self?.identifier)
                    }
                }
            } else {
                // Case: Non-interactive dismissal (e.g., programmatic dismissal)
                coordinator.parent?.removeChildCoordinatorForSwipeDismiss(with: self.identifier)
            }
        } else {
            // Not a dismissal, likely a push or presentation on top
        }
    }
}
