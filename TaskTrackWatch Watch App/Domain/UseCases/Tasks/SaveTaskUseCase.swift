import Foundation

/**
 * Validates and stores a task (insert or update).
 */
struct SaveTaskUseCase {
    let taskRepository: any TaskRepository
    let projectRepository: any ProjectRepository

    func callAsFunction(_ task: TaskItem) async throws {
        var task = task
        task.title = task.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !task.title.isEmpty else { throw DomainError.emptyName }
        guard try await projectRepository.fetch(id: task.projectID) != nil else {
            throw DomainError.projectNotFound
        }
        try await taskRepository.save(task)
    }
}
