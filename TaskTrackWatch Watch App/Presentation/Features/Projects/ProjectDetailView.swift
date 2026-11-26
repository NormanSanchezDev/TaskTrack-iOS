import SwiftUI

struct ProjectDetailView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel: ProjectDetailViewModel

    init(viewModel: ProjectDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        List {
            TaskRows(
                tasks: viewModel.tasks,
                project: { _ in viewModel.project },
                onDelete: delete
            )
        }
        .overlay {
            if viewModel.tasks.isEmpty && !viewModel.isLoading {
                ContentUnavailableView(
                    "No tasks",
                    systemImage: "checklist",
                    description: Text("Tap + to add one")
                )
            }
        }
        .navigationTitle(viewModel.project?.name ?? "Project")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Edit project", systemImage: "pencil") {
                    router.push(.projectForm(projectID: viewModel.projectID))
                }
                Spacer()
                Button("Add task", systemImage: "plus") {
                    router.push(.taskForm(taskID: nil, projectID: viewModel.projectID))
                }
            }
        }
        .task { await viewModel.load() }
        .alert("Something went wrong", isPresented: $viewModel.isShowingError) {
        } message: {
            Text(viewModel.errorMessage)
        }
    }

    private func delete(_ task: TaskItem) {
        Task { await viewModel.delete(task) }
    }
}
