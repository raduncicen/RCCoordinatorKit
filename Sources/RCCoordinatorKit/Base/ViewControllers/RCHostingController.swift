//
//  RCHostingController.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 25.02.2025.
//

import SwiftUI

public class RCHostingController<Content: View>: UIHostingController<Content>, RCViewControllerProtocol {
    private weak var coordinator: RCCoordinator?
    public var isCoordinatorRoot: Bool = false

    public init(
        rootView: Content,
        coordinator: RCCoordinator?
    ) {
        self.coordinator = coordinator
        super.init(rootView: rootView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Story board not supported")
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handleSwipeDismissForCoordinator(coordinator: coordinator)
    }
}
