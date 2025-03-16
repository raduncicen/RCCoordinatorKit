//
//  SceneDelegate.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import UIKit
import Factory

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let appWindow = Container.shared.appWindow()
        appWindow.windowScene = windowScene
        configureAppCoordinator()
    }

    private func configureAppCoordinator() {
        let coordinator = AppDIContainer.shared.appCoordinator()
        coordinator.start()
    }
    
}

