//
//  SettingsView.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 16.03.2025.
//

import RCCoordinatorKit
import RCPreviewKit
import SwiftUI

class SettingsViewController: RCHostingController<SettingsView> { }

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Text("Settings View")
    }
}

// MARK: - Preview

#Preview {
    RCPreviewer( { navigationController in
        SettingsDIContainer.shared.settingsViewController()
    })
}
