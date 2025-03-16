//
//  TabbarViewModel.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import SwiftUI

public protocol TabbarItemProtocol {

    var navigationTitle: String? { get }
    var name: String { get }
    var selectedImage: String { get }
    var unselectedImage: String { get }
}


class TabbarViewModel: ObservableObject {

    private let coordinator: TabbarCoordinator

    @Published var selectedTab = 0

    let items: [TabbarItemProtocol] = [
        HomeTabItem(),
        SettingsTabItem()
    ]

    init(coordinator: TabbarCoordinator) {
        self.coordinator = coordinator
    }
}

struct HomeTabItem: TabbarItemProtocol {
    var navigationTitle: String? = nil
    var name: String = "Home"
    var selectedImage: String = "house.fill"
    var unselectedImage: String = "house"
}

struct SettingsTabItem: TabbarItemProtocol {
    var navigationTitle: String? = nil
    var name: String = "Settings"
    var selectedImage: String = "gearshape.fill"
    var unselectedImage: String = "gearshape"
}
