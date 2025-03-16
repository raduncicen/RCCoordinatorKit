//
//  DummyViewController.swift
//  RCCoordinatorApp
//
//  Created by Radun Çiçen on 13.03.2025.
//

import RCCoordinatorKit
import SwiftUI

class DummyViewController: RCHostingController<DummyView> { }

struct DummyView: View {
    @ObservedObject var viewModel: DummyViewModel

    var body: some View {
        VStack {
            Text(viewModel.pageTitle)
                .font(.title)
            Spacer()
            ForEach(viewModel.buttons, id:\.title) { model in
                Button(model.title, action: model.onTap)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.blue))
            }
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    DummyView(
        viewModel: .init(
            pageTitle: "Some text",
            buttons: [
                .init(title: "First action", onTap: { }),
                .init(title: "Second action", onTap: { })
            ]
        )
    )
}


final class DummyViewModel: NestedObservedObjectListener {

    var pageTitle: String
    var buttons: [DummyButton]

    init(pageTitle: String, buttons: [DummyButton]) {
        self.pageTitle = pageTitle
        self.buttons = buttons
    }

}

struct DummyButton {
    var title: String
    var onTap: () -> Void
}
