import Foundation
import SwiftData

/**
 * `ProjectRepository` backed by a local SwiftData context.
 */
final class SwiftDataProjectRepository: ProjectRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() async throws -> [Project] {
        try context.fetch(FetchDescriptor<ProjectEntity>()).map(ProjectMapper.toDomain)
    }

    func fetch(id: UUID) async throws -> Project? {
        try entity(id: id).map(ProjectMapper.toDomain)
    }

    func fetchDefault() async throws -> Project? {
        var descriptor = FetchDescriptor<ProjectEntity>(predicate: #Predicate { $0.isDefault })
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first.map(ProjectMapper.toDomain)
    }

    func save(_ project: Project) async throws {
        if let existing = try entity(id: project.id) {
            ProjectMapper.apply(project, to: existing)
        } else {
            context.insert(ProjectMapper.makeEntity(from: project))
        }
        try context.save()
    }

    func delete(id: UUID) async throws {
        guard let existing = try entity(id: id) else { return }
        context.delete(existing)
        try context.save()
    }

    private func entity(id: UUID) throws -> ProjectEntity? {
        var descriptor = FetchDescriptor<ProjectEntity>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }
}
