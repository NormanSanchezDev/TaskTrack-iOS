import Foundation

/**
 * Returns the default "Inbox" project, creating it on first launch.
 */
struct EnsureDefaultProjectUseCase {
    static let defaultName = "Inbox"

    let repository: any ProjectRepository

    @discardableResult
    func callAsFunction() async throws -> Project {
        if let existing = try await repository.fetchDefault() {
            return existing
        }
        let inbox = Project(name: Self.defaultName, isDefault: true)
        try await repository.save(inbox)
        return inbox
    }
}
