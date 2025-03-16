//
//  NestedObservedObjectListener.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import Combine

/// This protocol is designed for objects that need to observe changes in nested observable objects and propagate those changes to their own subscribers.
protocol NestedObservedObjectListener: ObservableObject where Self.ObjectWillChangePublisher == ObservableObjectPublisher {}

extension NestedObservedObjectListener {
    func bindNestedObjectWillChange(cancellables: inout Set<AnyCancellable>, _ willChangePublishers: [ObservableObjectPublisher?] ) {
        Publishers.MergeMany(willChangePublishers.compactMap({$0})).sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        .store(in: &cancellables)
    }

    func bindNestedObjectWillChange(willChangePublishers: [ObservableObjectPublisher?]) -> AnyCancellable {
        Publishers.MergeMany(willChangePublishers.compactMap({$0})).sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
}
