import SwiftUI

struct TaskListView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel: TaskListViewModel

    init(viewModel: TaskListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        List {
            TaskRows(
                tasks: viewModel.tasks,
                project: { viewModel.projects[$0.projectID] },
                onDelete: delete
            )
        }
        .overlay {
            if viewModel.tasks.isEmpty && !viewModel.isLoading {
                ContentUnavailableView(
                    "No tasks yet",
                    systemImage: "checklist",
                    description: Text("Tap + to add one")
                )
            }
        }
        .navigationTitle("Tasks")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add task", systemImage: "plus") {
                    router.push(.taskForm(taskID: nil, projectID: nil))
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

#Preview {
    NavigationStack {
        TaskListView(viewModel: ViewModelFactory.preview().makeTaskListViewModel())
    }
    .environment(AppRouter())
}
