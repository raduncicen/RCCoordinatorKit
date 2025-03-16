//
//  AppManager.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import Foundation
import Combine

enum AppState: Equatable {
    case splash
    case onboarding
    case login
    case loggedIn
}

protocol AppManager {
    var appState: AppState { get }
    var appStatePublisher: AnyPublisher<AppState, Never> { get }
    func setState(_ state: AppState)
    func logout()
}

final class AppManagerImpl: ObservableObject, AppManager {

    @Published var appState: AppState = .splash
    var cancellables: Set<AnyCancellable> = []

    var appStatePublisher: AnyPublisher<AppState, Never> {
        $appState.eraseToAnyPublisher()
    }

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.setState(.login)
        })

        appStatePublisher.sink { state in
            print(state)
        }
        .store(in: &cancellables)
    }

    func setState(_ state: AppState) {
        appState = state
    }

    func logout() {
        appState = .login
    }
}
