import SwiftUI

/**
 * Owns the navigation path. Injected with `.environment(router)`
 * and read in screens with `@Environment(AppRouter.self)`.
 */
@Observable
final class AppRouter {
    var path: [AppRoute] = []

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
