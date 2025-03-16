//
//  SettingsDIContainer.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 16.03.2025.
//

import Factory
import UIKit

final class SettingsDIContainer: BaseDIContainer {
    static let shared = SettingsDIContainer()
    let manager = ContainerManager()

    private init() { }

    var settingsCoordinator: Factory<any SettingsCoordinator> {
        self {
            SettingsCoordinatorImpl(navigationController: self.common.appNavigationController())
        }
        .scope(.shared)
    }

    var settingsViewModel: Factory<SettingsViewModel> {
        self {
            SettingsViewModel(
                coordinator: self.settingsCoordinator(),
                state: .init(.init())
            )
        }
        .scope(.shared)
    }

    var settingsViewController: Factory<SettingsViewController> {
        self {
            let viewModel = self.settingsViewModel()
            let view = SettingsView(viewModel: viewModel)
            return SettingsViewController(
                rootView: view,
                coordinator: self.settingsCoordinator()
            )
        }
        .scope(.shared)
    }

}
