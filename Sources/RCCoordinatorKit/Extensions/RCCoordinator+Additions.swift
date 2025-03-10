//
//  RCCoordinator+Additions.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 25.02.2025.
//
import UIKit

private var identifierKey2: UInt8 = 0
extension RCCoordinator {
    internal var rootViewControllerIdentifier: String? {
        get { objc_getAssociatedObject(self, &identifierKey2) as? String }
        set { objc_setAssociatedObject(self, &identifierKey2, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
