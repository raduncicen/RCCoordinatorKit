//
//  RegisterView.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//
import RCCoordinatorKit
import RCPreviewKit
import SwiftUI

class RegisterViewController: RCHostingController<RegisterView> { }

struct RegisterView: View {
    @ObservedObject var viewModel: RegisterViewModel

    var body: some View {
        VStack {
            Text("Register First Page")

            Spacer()

            Button("Next page", action: viewModel.nextPage)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.blue))
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    RCPreviewer( { navigationController in
        RegisterDIContainer.shared.registerCoordinator().start()
        return nil
    })
}
