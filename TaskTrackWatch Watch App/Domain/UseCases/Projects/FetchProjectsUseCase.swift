import Foundation

/**
 * Returns projects with the default project first, then by name.
 */
struct FetchProjectsUseCase {
    let projectRepository: any ProjectRepository
    let taskRepository: any TaskRepository

    func callAsFunction() async throws -> [Project] {
        try await projectRepository.fetchAll().sorted { lhs, rhs in
            if lhs.isDefault != rhs.isDefault { return lhs.isDefault }
            return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        }
    }

    func one(id: UUID) async throws -> Project? {
        try await projectRepository.fetch(id: id)
    }

    func taskCount(projectID: UUID) async throws -> Int {
        try await taskRepository.count(projectID: projectID)
    }
}
