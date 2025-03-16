//
//  SettingsCoordinator.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 16.03.2025.
//

import RCCoordinatorKit
import SwiftUI

protocol SettingsCoordinatorDelegate: RCCoordinatorDelegate {}

protocol SettingsCoordinator: RCCoordinator {
    func startAsTab() -> UIViewController
}

class SettingsCoordinatorImpl: RCBaseCoordinator<SettingsCoordinatorDelegate>, SettingsCoordinator {

    func startAsTab()  -> UIViewController {
        let viewController = SettingsDIContainer.shared.settingsViewController()
        matchCoordinatorIdWithRootViewController(viewController)
        return viewController
    }
}
