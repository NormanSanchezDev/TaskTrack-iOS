import Foundation

/**
 * Validates and stores a project (insert or update).
 */
struct SaveProjectUseCase {
    let repository: any ProjectRepository

    func callAsFunction(_ project: Project) async throws {
        var project = project
        project.name = project.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !project.name.isEmpty else { throw DomainError.emptyName }
        try await repository.save(project)
    }
}
