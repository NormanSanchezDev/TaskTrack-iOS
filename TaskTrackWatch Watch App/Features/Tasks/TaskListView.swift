import SwiftUI

struct TaskListView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: "checklist")
                .font(.title2)
                .foregroundStyle(.secondary)
            TTText(model: .init(text: "No tasks yet", type: .body))
            TTText(model: .init(text: "Tap + to add one", type: .caption))
        }
        .navigationTitle("Tasks")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add task", systemImage: "plus") {
                    router.push(.addTask)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TaskListView()
    }
    .environment(AppRouter())
}
