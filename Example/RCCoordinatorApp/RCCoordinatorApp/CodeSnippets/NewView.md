//  Created by Radun Çiçen on 13.03.2025.


```
import RCCoordinatorKit
import RCPreviewKit
import SwiftUI

class <###Name###>ViewController: RCHostingController<<###Name###>View> { }

struct <###Name###>View: View {
    @ObservedObject var viewModel: <###Name###>ViewModel

    var body: some View {
        Text("New View")
    }
}

// MARK: - Preview

#Preview {
    RCPreviewer( { navigationController in
        <###ContainerName###>DIContainer.shared.<###name###>ViewController()
    })
}
```
