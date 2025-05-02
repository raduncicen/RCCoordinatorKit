//  Created by Radun Çiçen on 13.03.2025.
//

```
import Factory
import UIKit

final class <###Name###>DIContainer: BaseDIContainer {
    static let shared = <###Name###>DIContainer()
    let manager = ContainerManager()

    private init() { }

    var <###name###>Coordinator: Factory<any <###Name###>Coordinator> {
        self {
            <###Name###>CoordinatorImpl(navigationController: self.common.appNavigationController())
        }
        .scope(.shared)
    }

    var <###name###>ViewModel: Factory<<###Name###>ViewModel> {
        self {
            <###Name###>ViewModel(
                coordinator: self.<###CoordinatorName###>()
            )
        }
        .scope(.shared)
    }

    var <###name###>ViewController: Factory<<###Name###>ViewController> {
        self {
            let viewModel = self.<###name###>ViewModel()
            let view = <###Name###>View(viewModel: viewModel)
            return <###Name###>ViewController(
                rootView: view,
                coordinator: self.<###CoordinatorName###>()
            )
        }
        .scope(.shared)
    }
}
```
