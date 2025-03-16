//
//  Container+Extension.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import Factory
import UIKit

extension Container {

    var appWindow: Factory<UIWindow> {
        self {
            MainActor.assumeIsolated { UIWindow() }
        }
        .scope(.shared)
    }

    var appNavigationController: Factory<UINavigationController> {
        self {
            MainActor.assumeIsolated { .init() }
        }
        .scope(.shared)
    }

    var appManager: Factory<AppManager> {
        self { AppManagerImpl() }
            .scope(.singleton)
    }

}
