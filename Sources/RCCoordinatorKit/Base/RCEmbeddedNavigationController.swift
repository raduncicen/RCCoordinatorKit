//
//  RCEmbeddedNavigationController.swift
//  RCCoordinatorKit
//
//  Created by Radun Çiçen on 16.03.2025.
//

import UIKit

public class RCEmbeddedNavigationController: UINavigationController, RCViewControllerProtocol {
    private weak var coordinator: RCCoordinator?
    public var isCoordinatorRoot: Bool = false

    public init(rootViewController: UIViewController, coordinator: RCCoordinator?) {
        self.coordinator = coordinator
        super.init(rootViewController: rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Story board not supported")
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handleSwipeDismissForCoordinator(coordinator: coordinator)
    }
}
