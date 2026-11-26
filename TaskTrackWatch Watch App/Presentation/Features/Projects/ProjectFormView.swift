import SwiftUI

struct ProjectFormView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel: ProjectFormViewModel

    init(viewModel: ProjectFormViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Form {
            TextField("Project name", text: $viewModel.name)

            Picker("Color", selection: $viewModel.colorHex) {
                ForEach(ProjectColor.all, id: \.self) { hex in
                    Label {
                        Text(ProjectColor.name(for: hex))
                    } icon: {
                        Circle().fill(Color(hex: hex))
                    }
                    .tag(hex)
                }
            }

            Picker("Emoji", selection: $viewModel.emoji) {
                ForEach(ProjectEmoji.all, id: \.self) { emoji in
                    Text(emoji)
                        .tag(emoji)
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
        .navigationTitle(viewModel.isEditing ? "Edit project" : "New project")
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
        ProjectFormView(viewModel: ViewModelFactory.preview().makeProjectFormViewModel(projectID: nil))
    }
    .environment(AppRouter())
}
