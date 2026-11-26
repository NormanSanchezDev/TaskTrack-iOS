import Foundation

/**
 * Removes a task.
 */
struct DeleteTaskUseCase {
    let repository: any TaskRepository

    func callAsFunction(id: UUID) async throws {
        try await repository.delete(id: id)
    }
}
