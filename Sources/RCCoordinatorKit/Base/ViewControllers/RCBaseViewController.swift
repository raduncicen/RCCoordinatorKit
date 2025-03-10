//
//  RCBaseViewController.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 25.02.2025.
//
import UIKit

public class RCBaseViewController: UIViewController, RCViewControllerProtocol {
    private weak var coordinator: RCCoordinator?
    public var isCoordinatorRoot: Bool = false

    public init(coordinator: RCCoordinator?) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Story board not supported")
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handleSwipeDismissForCoordinator(coordinator: coordinator)
    }
}
