//
//  BaseDIContainer.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import Factory

protocol BaseDIContainer: SharedContainer {
    var common: Container { get }
}

extension BaseDIContainer {
    var common: Container { .shared }
}
