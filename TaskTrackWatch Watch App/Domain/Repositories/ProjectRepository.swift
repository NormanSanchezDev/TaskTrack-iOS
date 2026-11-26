import Foundation

/**
 * Storage abstraction for projects. Deleting a project deletes its tasks.
 */
protocol ProjectRepository {
    func fetchAll() async throws -> [Project]
    func fetch(id: UUID) async throws -> Project?
    func fetchDefault() async throws -> Project?
    func save(_ project: Project) async throws
    func delete(id: UUID) async throws
}
