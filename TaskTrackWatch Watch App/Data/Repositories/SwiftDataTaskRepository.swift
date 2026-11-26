import Foundation
import SwiftData

/**
 * `TaskRepository` backed by a local SwiftData context.
 */
final class SwiftDataTaskRepository: TaskRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll(projectID: UUID?) async throws -> [TaskItem] {
        try context.fetch(descriptor(projectID: projectID)).compactMap(TaskMapper.toDomain)
    }

    func fetch(id: UUID) async throws -> TaskItem? {
        try entity(id: id).flatMap(TaskMapper.toDomain)
    }

    func save(_ task: TaskItem) async throws {
        guard let project = try projectEntity(id: task.projectID) else {
            throw DomainError.projectNotFound
        }
        if let existing = try entity(id: task.id) {
            TaskMapper.apply(task, project: project, to: existing)
        } else {
            context.insert(TaskMapper.makeEntity(from: task, project: project))
        }
        try context.save()
    }

    func delete(id: UUID) async throws {
        guard let existing = try entity(id: id) else { return }
        context.delete(existing)
        try context.save()
    }

    func count(projectID: UUID) async throws -> Int {
        try context.fetchCount(descriptor(projectID: projectID))
    }

    private func descriptor(projectID: UUID?) -> FetchDescriptor<TaskEntity> {
        guard let projectID else { return FetchDescriptor<TaskEntity>() }
        return FetchDescriptor<TaskEntity>(predicate: #Predicate { $0.project?.id == projectID })
    }

    private func entity(id: UUID) throws -> TaskEntity? {
        var descriptor = FetchDescriptor<TaskEntity>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    private func projectEntity(id: UUID) throws -> ProjectEntity? {
        var descriptor = FetchDescriptor<ProjectEntity>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }
}
