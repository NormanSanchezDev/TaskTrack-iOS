import Foundation

/**
 * Domain representation of a task. Every task belongs to a project.
 */
struct TaskItem: Identifiable, Equatable, Sendable {
    let id: UUID
    var title: String
    var status: TaskStatus
    var dueDate: Date
    var assignee: String?
    var projectID: UUID
    let createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        status: TaskStatus = .todo,
        dueDate: Date = .now,
        assignee: String? = Assignee.defaultName,
        projectID: UUID,
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.status = status
        self.dueDate = dueDate
        self.assignee = assignee
        self.projectID = projectID
        self.createdAt = createdAt
    }
}
