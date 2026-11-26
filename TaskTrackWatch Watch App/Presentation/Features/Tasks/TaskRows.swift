import SwiftUI

/**
 * Tappable task rows with swipe-to-delete, shared by the task list and project detail.
 */
struct TaskRows: View {
    let tasks: [TaskItem]
    let project: (TaskItem) -> Project?
    let onDelete: (TaskItem) -> Void

    @Environment(AppRouter.self) private var router

    var body: some View {
        ForEach(tasks) { task in
            Button {
                router.push(.taskForm(taskID: task.id, projectID: nil))
            } label: {
                TaskRow(task: task, project: project(task))
            }
            .swipeActions {
                Button("Delete", systemImage: "trash", role: .destructive) {
                    onDelete(task)
                }
            }
        }
    }
}
