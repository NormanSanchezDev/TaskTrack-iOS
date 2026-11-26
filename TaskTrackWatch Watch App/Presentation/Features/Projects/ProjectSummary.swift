import Foundation

/**
 * A project together with its number of tasks, for list display.
 */
struct ProjectSummary: Identifiable, Equatable {
    let project: Project
    let taskCount: Int

    var id: UUID { project.id }
}
