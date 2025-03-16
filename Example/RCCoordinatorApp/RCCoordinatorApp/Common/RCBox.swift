//
//  RCBox.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import Foundation
import Combine

@dynamicMemberLookup
class RCBox<T>: ObservableObject {
    @Published var value: T

    init(_ value: T) {
        self.value = value
    }

    // Subscript to access properties dynamically
    subscript<U>(dynamicMember keyPath: KeyPath<T, U>) -> U {
        return value[keyPath: keyPath]
    }

    // Subscript to mutate properties dynamically
    subscript<U>(dynamicMember keyPath: WritableKeyPath<T, U>) -> U {
        get {
            return value[keyPath: keyPath]
        }
        set {
            value[keyPath: keyPath] = newValue
        }
    }
}
