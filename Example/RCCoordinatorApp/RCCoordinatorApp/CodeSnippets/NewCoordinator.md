
A code-snippet for quick initialization of a new Coordinator

```
import RCCoordinatorKit
import SwiftUI

protocol <###Name###>CoordinatorDelegate: RCCoordinatorDelegate {}

protocol <###Name###>Coordinator: RCCoordinator {
    func start()
}

class <###Name###>CoordinatorImpl: RCBaseCoordinator<<###Name###>CoordinatorDelegate>, <###Name###>Coordinator {

    func start() {

    }
}
```
