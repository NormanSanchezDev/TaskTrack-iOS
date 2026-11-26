import Foundation

/**
 * Converts between `TaskEntity` and the `TaskItem` domain model.
 * Returns `nil` for orphan entities without a project.
 */
enum TaskMapper {
    static func toDomain(_ entity: TaskEntity) -> TaskItem? {
        guard let projectID = entity.project?.id else { return nil }
        return TaskItem(
            id: entity.id,
            title: entity.title,
            status: TaskStatus(rawValue: entity.statusRaw) ?? .todo,
            dueDate: entity.dueDate,
            assignee: entity.assignee,
            projectID: projectID,
            createdAt: entity.createdAt
        )
    }

    static func makeEntity(from task: TaskItem, project: ProjectEntity) -> TaskEntity {
        TaskEntity(
            id: task.id,
            title: task.title,
            statusRaw: task.status.rawValue,
            dueDate: task.dueDate,
            assignee: task.assignee,
            createdAt: task.createdAt,
            project: project
        )
    }

    static func apply(_ task: TaskItem, project: ProjectEntity, to entity: TaskEntity) {
        entity.title = task.title
        entity.statusRaw = task.status.rawValue
        entity.dueDate = task.dueDate
        entity.assignee = task.assignee
        entity.project = project
    }
}
