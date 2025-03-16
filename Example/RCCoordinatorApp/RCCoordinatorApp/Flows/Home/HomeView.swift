//
//  HomeView.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 16.03.2025.
//

import RCCoordinatorKit
import RCPreviewKit
import SwiftUI

class HomeViewController: RCHostingController<HomeView> { }

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        Text("Home View")
    }
}

// MARK: - Preview

#Preview {
    RCPreviewer( { navigationController in
        HomeDIContainer.shared.homeViewController()
    })
}
