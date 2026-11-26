import Foundation

/**
 * Deletes a project and its tasks. The default project is protected.
 */
struct DeleteProjectUseCase {
    let repository: any ProjectRepository

    func callAsFunction(id: UUID) async throws {
        guard let project = try await repository.fetch(id: id) else {
            throw DomainError.projectNotFound
        }
        guard !project.isDefault else { throw DomainError.cannotDeleteDefaultProject }
        try await repository.delete(id: id)
    }
}
