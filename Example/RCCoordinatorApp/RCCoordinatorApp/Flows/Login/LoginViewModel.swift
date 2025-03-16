//
//  LoginViewModel.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import Combine
import Factory
import Foundation

struct LoginState {
    var email: String = ""
    var password: String = ""
}

class LoginViewModel: NestedObservedObjectListener {
    // Public values
    @Published var state: RCBox<LoginState>
    // Private values
    @Injected(\.appManager) private var appManager
    private let coordinator: LoginCoordinator
    private var cancellables: Set<AnyCancellable> = []

    init(
        coordinator: LoginCoordinator,
        state: RCBox<LoginState>
    ) {
        self.coordinator = coordinator
        self.state = state

        bindNestedObjectWillChange(cancellables: &cancellables, [state.objectWillChange])
    }

    func login() {
        guard !state.email.isEmpty && !state.password.isEmpty else { return }
        
        // Here you can either use appManager and set appState to update the current appRoute
        // appManager.setState(.loggedIn)
        // OR
        coordinator.showTabbar()
    }

    func showRegister() {
        coordinator.showRegisterFlow()
    }
}



