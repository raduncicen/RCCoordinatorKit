//
//  LoginView.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import RCCoordinatorKit
import RCPreviewKit
import SwiftUI

class LoginViewController: RCHostingController<LoginView> { }

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            Group {
                TextField("Enter Email", text: $viewModel.state.email)
                TextField("Enter Password", text: $viewModel.state.password)
            }
            .frame(height: 44)
            .padding(.horizontal)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.secondary)
            }
            registerButton
                .padding(.top)
            Spacer()
            continueButton
        }
        .navigationTitle("Login")
        .padding()
    }

    private var registerButton: some View {
        Button(action: viewModel.showRegister) {
            Text("Register (Starts registerFlow)")
        }
    }

    private var continueButton: some View {
        Button(action: viewModel.login) {
            Text("Login")
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
        }
        .background { RoundedRectangle(cornerRadius: 12).fill(Color.blue) }
    }
}

// MARK: - Preview

#Preview {
    RCPreviewer { navigationController in
        LoginDIContainer.shared.loginViewController()
    }
}
