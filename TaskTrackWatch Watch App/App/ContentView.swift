import SwiftUI

struct ContentView: View {
    let factory: ViewModelFactory

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
        .task { await factory.ensureDefaultProject() }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .taskList:
            TaskListView(viewModel: factory.makeTaskListViewModel())
        case .taskForm(let taskID, let projectID):
            TaskFormView(viewModel: factory.makeTaskFormViewModel(taskID: taskID, projectID: projectID))
        case .projectList:
            ProjectListView(viewModel: factory.makeProjectListViewModel())
        case .projectDetail(let projectID):
            ProjectDetailView(viewModel: factory.makeProjectDetailViewModel(projectID: projectID))
        case .projectForm(let projectID):
            ProjectFormView(viewModel: factory.makeProjectFormViewModel(projectID: projectID))
        case .pomodoro:
            ComingSoonView(title: HomeDestination.pomodoro.title, systemImage: HomeDestination.pomodoro.systemImage)
        case .settings:
            ComingSoonView(title: HomeDestination.settings.title, systemImage: HomeDestination.settings.systemImage)
        }
    }
}

#Preview {
    ContentView(factory: .preview())
}
