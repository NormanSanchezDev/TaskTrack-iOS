import Foundation

/**
 * Storage abstraction for tasks.
 */
protocol TaskRepository {
    func fetchAll(projectID: UUID?) async throws -> [TaskItem]
    func fetch(id: UUID) async throws -> TaskItem?
    func save(_ task: TaskItem) async throws
    func delete(id: UUID) async throws
    func count(projectID: UUID) async throws -> Int
}
