import SwiftUI

struct TaskFormView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel: TaskFormViewModel

    init(viewModel: TaskFormViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Form {
            TextField("Task name", text: $viewModel.title)

            Picker("Status", selection: $viewModel.status) {
                ForEach(TaskStatus.allCases) { status in
                    Label(status.title, systemImage: status.systemImage)
                        .tag(status)
                }
            }

            DueDateField(selection: $viewModel.dueDate)

            Toggle(isOn: $viewModel.isAssigned) {
                VStack(alignment: .leading) {
                    Text("Assign to")
                    Text(viewModel.assigneeName)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Picker("Project", selection: $viewModel.projectID) {
                ForEach(viewModel.projects) { project in
                    Text(project.name)
                        .tag(Optional(project.id))
                }
            }

            Section {
                TTButton(
                    model: .init(
                        text: viewModel.isEditing ? "Update" : "Save",
                        trailingIcon: "checkmark",
                        type: .filled,
                        action: save
                    )
                )
                .disabled(!viewModel.canSave)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle(viewModel.isEditing ? "Edit task" : "New task")
        .task { await viewModel.load() }
        .alert("Couldn't save", isPresented: $viewModel.isShowingError) {
        } message: {
            Text(viewModel.errorMessage)
        }
    }

    private func save() {
        Task {
            if await viewModel.save() {
                router.pop()
            }
        }
    }
}

#Preview {
    NavigationStack {
        TaskFormView(viewModel: ViewModelFactory.preview().makeTaskFormViewModel(taskID: nil, projectID: nil))
    }
    .environment(AppRouter())
}
