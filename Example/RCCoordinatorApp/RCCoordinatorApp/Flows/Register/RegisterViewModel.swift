//
//  RegisterViewModel.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import Combine
import Foundation

struct RegisterState {

}

class RegisterViewModel: NestedObservedObjectListener {
    // Public values
    @Published var state: RCBox<RegisterState>
    // Private values
    private let coordinator: RegisterCoordinator
    private var cancellables: Set<AnyCancellable> = []

    init(
        coordinator: RegisterCoordinator,
        state: RCBox<RegisterState>
    ) {
        self.coordinator = coordinator
        self.state = state

        bindNestedObjectWillChange(cancellables: &cancellables, [state.objectWillChange])
    }

    func nextPage() {
        coordinator.showRegisterStep2()
    }
}

