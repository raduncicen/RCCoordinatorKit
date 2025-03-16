//  Created by Radun Çiçen on 13.03.2025.

```
import Combine
import Foundation

struct <###Name###>State {

}

final class <###Name###>ViewModel: NestedObservedObjectListener {
    // Public values
    @Published var state: RCBox<<###Name###>State>
    // Private values
    private let coordinator: <###CoordinatorName###>
    private var cancellables: Set<AnyCancellable> = []

    init(
        coordinator: <###CoordinatorName###>,
        state: RCBox<<###Name###>State>
    ) {
        self.coordinator = coordinator
        self.state = state

        bindNestedObjectWillChange(cancellables: &cancellables, [state.objectWillChange])
    }

}
```
