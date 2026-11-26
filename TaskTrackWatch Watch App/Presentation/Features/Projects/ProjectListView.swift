import SwiftUI

struct ProjectListView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel: ProjectListViewModel

    init(viewModel: ProjectListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        List {
            ForEach(viewModel.summaries) { summary in
                Button {
                    router.push(.projectDetail(projectID: summary.id))
                } label: {
                    ProjectRow(summary: summary)
                }
                .swipeActions(edge: .leading) {
                    Button("Edit", systemImage: "pencil") {
                        router.push(.projectForm(projectID: summary.id))
                    }
                }
                .swipeActions(edge: .trailing) {
                    if !summary.project.isDefault {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            viewModel.requestDeletion(of: summary)
                        }
                    }
                }
            }
        }
        .confirmationDialog(
            "Delete project?",
            isPresented: $viewModel.isConfirmingDeletion,
            presenting: viewModel.pendingDeletion
        ) { summary in
            Button("Delete \(summary.project.name)", role: .destructive, action: confirmDeletion)
        } message: { summary in
            Text("Its \(summary.taskCount) tasks will be deleted too.")
        }
        .navigationTitle("Projects")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add project", systemImage: "plus") {
                    router.push(.projectForm(projectID: nil))
                }
            }
        }
        .task { await viewModel.load() }
        .alert("Something went wrong", isPresented: $viewModel.isShowingError) {
        } message: {
            Text(viewModel.errorMessage)
        }
    }

    private func confirmDeletion() {
        Task { await viewModel.confirmDeletion() }
    }
}

#Preview {
    NavigationStack {
        ProjectListView(viewModel: ViewModelFactory.preview().makeProjectListViewModel())
    }
    .environment(AppRouter())
}
