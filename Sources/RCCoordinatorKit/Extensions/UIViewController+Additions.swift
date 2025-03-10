//
//  UIViewController+Additions.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 25.02.2025.
//
import UIKit

private var identifierKey: UInt8 = 0

extension UIViewController {
    public var identifier: String? {
        get { return objc_getAssociatedObject(self, &identifierKey) as? String }
        set { objc_setAssociatedObject(self, &identifierKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
