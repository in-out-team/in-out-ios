import Combine
import UIKit

class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        let didShowPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)
        let didHidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)

        didShowPublisher
            .merge(with: didHidePublisher)
            .sink { [weak self] notification in
                DispatchQueue.main.async {
                    if notification.name == UIResponder.keyboardDidShowNotification {
                        self?.isKeyboardVisible = true
                    } else if notification.name == UIResponder.keyboardDidHideNotification {
                        self?.isKeyboardVisible = false
                    }
                }
            }
            .store(in: &cancellables)

    }
}
