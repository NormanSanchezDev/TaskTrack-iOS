import Foundation
import SwiftData

/**
 * SwiftData storage model for a task.
 */
@Model
final class TaskEntity {
    @Attribute(.unique) var id: UUID
    var title: String
    var statusRaw: String
    var dueDate: Date
    var assignee: String?
    var createdAt: Date
    var project: ProjectEntity?

    init(
        id: UUID,
        title: String,
        statusRaw: String,
        dueDate: Date,
        assignee: String?,
        createdAt: Date,
        project: ProjectEntity?
    ) {
        self.id = id
        self.title = title
        self.statusRaw = statusRaw
        self.dueDate = dueDate
        self.assignee = assignee
        self.createdAt = createdAt
        self.project = project
    }
}
