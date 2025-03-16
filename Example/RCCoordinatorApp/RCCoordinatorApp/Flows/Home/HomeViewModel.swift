//
//  HomeViewModel.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 16.03.2025.
//

import Combine
import Foundation

struct HomeState {

}

final class HomeViewModel: NestedObservedObjectListener {
    // Public values
    @Published var state: RCBox<HomeState>
    // Private values
    private let coordinator: HomeCoordinator
    private var cancellables: Set<AnyCancellable> = []

    init(
        coordinator: HomeCoordinator,
        state: RCBox<HomeState>
    ) {
        self.coordinator = coordinator
        self.state = state

        bindNestedObjectWillChange(cancellables: &cancellables, [state.objectWillChange])
    }

}
