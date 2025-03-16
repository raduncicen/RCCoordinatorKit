//
//  TabbarViewController.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//
import RCCoordinatorKit
import RCPreviewKit
import SwiftUI

final class TabbarViewController: UITabBarController, RCViewControllerProtocol ,UITabBarControllerDelegate {

    // Public properties
    var isCoordinatorRoot: Bool = false

    // Private properties
    private weak var coordinator: RCCoordinator?
    private let viewModel: TabbarViewModel
    private var makeViewControllersFactory: (() -> ([UIViewController]?))

    init(
        viewModel: TabbarViewModel,
        makeViewControllersFactory: @escaping () -> [UIViewController]?
    ) {
        self.viewModel = viewModel
        self.makeViewControllersFactory = makeViewControllersFactory
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = self
        self.changeTitle(viewModel.items[viewModel.selectedTab])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
        configureStyle()
    }

    func configureTabs() {
        guard let controllers = makeViewControllersFactory()  else { return }
        setViewControllers(controllers, animated: false)

        viewModel.items.enumerated().forEach { (index, item) in
            viewControllers?[index].tabBarItem = UITabBarItem(
                title: item.name,
                image: .init(systemName: item.unselectedImage),
                selectedImage: .init(systemName: item.selectedImage)
            )
        }
    }

    func configureStyle() {
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]

        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]

        let tabbarAppearance = UITabBar.appearance()
        // Selected icon/text color
        tabbarAppearance.tintColor = .red
        // Unselected icon/text color
        tabbarAppearance.unselectedItemTintColor = .gray

        // Font Customization
        let itemAppearance = UITabBarItem.appearance()
        itemAppearance.setTitleTextAttributes(normalAttributes, for: .normal)
        itemAppearance.setTitleTextAttributes(selectedAttributes, for: .selected)

        let appearance = UITabBarAppearance()
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }

    private func changeTitle(_ selectedTab: TabbarItemProtocol) {
        DispatchQueue.main.async { [weak self] in
            guard let self, let title = selectedTab.navigationTitle else {
                return
            }

            self.navigationItem.titleView = getNavigationBarTitleTextView(with: title)
            self.navigationItem.title = nil
        }
    }

    func changeTab(index: Int) {
        selectedIndex = index
        let item = self.viewModel.items[selectedIndex]
        changeTitle(item)
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.selectedIndex
        let item = self.viewModel.items[selectedIndex]
        changeTitle(item)
    }

    func getNavigationBarTitleTextView(with: String) -> UITextView {
        let textView = UITextView()
        textView.attributedText = NSAttributedString(
            string: with,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor(.secondary)
            ]
        )
        return textView
    }

}

// MARK: - Preview

#Preview {
    RCPreviewer( { navigationController in
        TabbarDIContainer.shared.tabbarCoordinator().start()
        return nil
    })
}
