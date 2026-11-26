import SwiftUI

struct ContentView: View {
    @State private var router = AppRouter()
    @Environment(\.ttTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: AppRoute.self, destination: destination)
        }
        .containerBackground(theme.palette(for: colorScheme).primary.gradient, for: .navigation)
        .environment(router)
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .taskList:
            TaskListView()
        case .addTask:
            AddTaskView()
        }
    }
}

#Preview {
    ContentView()
}
