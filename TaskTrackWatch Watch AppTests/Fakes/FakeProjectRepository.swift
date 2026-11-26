import Foundation
@testable import TaskTrackWatch_Watch_App

@MainActor
final class FakeProjectRepository: ProjectRepository {
    var projects: [UUID: Project] = [:]

    func fetchAll() async throws -> [Project] { Array(projects.values) }
    func fetch(id: UUID) async throws -> Project? { projects[id] }
    func fetchDefault() async throws -> Project? { projects.values.first { $0.isDefault } }
    func save(_ project: Project) async throws { projects[project.id] = project }
    func delete(id: UUID) async throws { projects[id] = nil }
}
