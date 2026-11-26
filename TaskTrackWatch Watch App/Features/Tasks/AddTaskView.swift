import SwiftUI

struct AddTaskView: View {
    @Environment(AppRouter.self) private var router
    @State private var title = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                TextField("Task name", text: $title)

                TTButton(
                    model: .init(text: "Save", trailingIcon: "checkmark", type: .filled) {
                        router.pop()
                    }
                )
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)

                TTButton(
                    model: .init(text: "Cancel", type: .text) {
                        router.pop()
                    }
                )
            }
        }
        .navigationTitle("New task")
    }
}

#Preview {
    NavigationStack {
        AddTaskView()
    }
    .environment(AppRouter())
}
