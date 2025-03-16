//
//  HomeCoordinator.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 16.03.2025.
//

import RCCoordinatorKit
import SwiftUI

protocol HomeCoordinatorDelegate: RCCoordinatorDelegate {}

protocol HomeCoordinator: RCCoordinator {
    func startAsTab() -> UIViewController
}

class HomeCoordinatorImpl: RCBaseCoordinator<HomeCoordinatorDelegate>, HomeCoordinator {

    func startAsTab() -> UIViewController {
        let viewController = HomeDIContainer.shared.homeViewController()
        matchCoordinatorIdWithRootViewController(viewController)
        return viewController
    }
}
