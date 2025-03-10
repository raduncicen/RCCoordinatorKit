//
//  RCBaseCoordinator.swift
//  CoordinatorExample
//
//  Created by Radun Çiçen on 1.03.2025.
//

import SwiftUI

public class RCBaseCoordinator<CoordinatorDelegate>: RCCoordinator {
    
    public var navigationController: UINavigationController
    public var childCoordinators: [any RCCoordinator] = []

    weak private var weakParent: AnyObject?

    public var typedParent: CoordinatorDelegate? {
        get { weakParent as? CoordinatorDelegate }
        set { weakParent = newValue as? AnyObject }
    }

    public var parent: (any RCCoordinatorDelegate)? {
        get { weakParent as? RCCoordinatorDelegate }
        set {
            guard newValue != nil else {
                weakParent = nil
                return
            }
            if !(newValue is CoordinatorDelegate) {
                assertionFailure("In correct navDelegate type.")
            }
            weakParent = newValue
        }
    }

    required public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(popUpTo identifier: String?) {
        assertionFailure("Not implemented")
    }
}
