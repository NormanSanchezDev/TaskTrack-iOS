import Foundation

/**
 * Returns tasks, optionally filtered by project, sorted by due date.
 */
struct FetchTasksUseCase {
    let repository: any TaskRepository

    func callAsFunction(projectID: UUID? = nil) async throws -> [TaskItem] {
        try await repository.fetchAll(projectID: projectID)
            .sorted { $0.dueDate < $1.dueDate }
    }

    func one(id: UUID) async throws -> TaskItem? {
        try await repository.fetch(id: id)
    }
}
