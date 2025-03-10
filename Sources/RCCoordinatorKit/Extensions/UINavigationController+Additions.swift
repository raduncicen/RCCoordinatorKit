//
//  UINavigationController+Additions.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 25.02.2025.
//
import UIKit

public extension UINavigationController {

    private func viewControllerIndex(withId identifier: String?) -> Int? {
        guard let identifier else {
            assertionFailure("The provided viewControllerIdentifier is nil")
            return nil
        }

        let currentStack = viewControllers
        guard !currentStack.isEmpty else {
            assertionFailure("NavigationController.viewControllers is empty")
            return nil
        }

        guard let targetIndex = currentStack.lastIndex(where: { $0.identifier == identifier }) else {
            debugPrint("Warning: Target ViewController with not found in navigation stack")
            return nil
        }
        return targetIndex
    }

    /// Pops view controllers from the navigation stack up to a specified view controller identified by an `identifier`.
    /// This allows you to selectively retain or exclude the identified view controller in the navigation stack.
    ///
    /// - Parameters:
    ///   - identifier: A `String` identifier of the target view controller to pop up to. This should match the `identifier` property on the target view controller.
    ///   - include: A `Bool` flag indicating whether to include the identified view controller in the new navigation stack.
    ///              - `true`: The identified view controller will not remain in the navigation stack (default).
    ///              - `false`: The identified view controller will be included in the navigation stack.
    ///   - animated: A `Bool` flag specifying whether the transition should be animated. Defaults to `true`.
    ///   - completion: An optional completion handler (`(() -> Void)?`) called after the pop action completes.
    ///
    /// - Behavior:
    ///   - If the `identifier` is `nil`, the function will trigger an assertion failure.
    ///   - If the `identifier` is not found in the current navigation stack, the function will log a warning message and exit without modifying the stack.
    ///   - If the current navigation stack is empty, an assertion failure is triggered.
    ///   - When the target view controller is found, the function will set a new navigation stack up to that view controller.
    ///     - If `include` is `true`, the new stack will exclude the identified view controller.
    ///     - If `include` is `false`, the identified view controller will be retained in the new stack.
    ///   - The `setViewControllers(_:animated:)` method is used to apply the updated navigation stack with or without animation.
    ///   - If a `completion` closure is provided, it will be executed once the transition animation completes.
    ///
    /// - Example Usage:
    ///   ```swift
    ///   // Assuming a navigation stack with identifiers "Home", "Settings", and "Profile".
    ///   navigationController.popViewControllers(upTo: "Settings", include: true, animated: true) {
    ///       print("Finished popping to the target view controller")
    ///   }
    ///   ```
    ///
    /// - Remarks:
    ///   - Ensure that each view controller in the navigation stack has a unique identifier assigned to its `identifier` property.
    ///   - Using `CATransaction` ensures that the completion handler is called after the animated transition completes.
    func popViewControllers(upTo identifier: String?, include: Bool = true, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let targetIndex = viewControllerIndex(withId: identifier) else { return }

        let identifiedViewController = viewControllers[targetIndex]
        let newStack: [UIViewController]
        if include {
            newStack = Array(viewControllers[..<targetIndex])
        } else {
            newStack = Array(viewControllers[..<targetIndex]) + [identifiedViewController]
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }

        setViewControllers(newStack, animated: animated)
        CATransaction.commit()
    }

    @discardableResult
    public func setNavigationStack(
        upTo viewControllerIdentifier: String? = nil,
        include: Bool = true,
        adding newViewController: UIViewController? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) -> Bool {
        guard let targetIndex = viewControllerIndex(withId: viewControllerIdentifier) else {
            return false
        }
        let identifiedViewController = viewControllers[targetIndex]
        var newStack: [UIViewController]

        if include {
            newStack = Array(viewControllers[..<targetIndex])
        } else {
            newStack = Array(viewControllers[..<targetIndex]) + [identifiedViewController]
        }

        if let newViewController {
            newStack += [newViewController]
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }

        setViewControllers(newStack, animated: animated)
        CATransaction.commit()

        return true
    }
}
