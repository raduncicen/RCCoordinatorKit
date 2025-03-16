//
//  SettingsViewModel.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 16.03.2025.
//

import Combine
import Foundation

struct SettingsState {

}

final class SettingsViewModel: NestedObservedObjectListener {
    // Public values
    @Published var state: RCBox<SettingsState>
    // Private values
    private let coordinator: SettingsCoordinator
    private var cancellables: Set<AnyCancellable> = []

    init(
        coordinator: SettingsCoordinator,
        state: RCBox<SettingsState>
    ) {
        self.coordinator = coordinator
        self.state = state

        bindNestedObjectWillChange(cancellables: &cancellables, [state.objectWillChange])
    }

}
