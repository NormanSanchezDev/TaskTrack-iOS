import Foundation
import SwiftData

/**
 * Composition root. Owns the SwiftData container and the repositories.
 */
final class AppDependencies {
    let container: ModelContainer
    let taskRepository: any TaskRepository
    let projectRepository: any ProjectRepository

    init(container: ModelContainer) {
        self.container = container
        self.taskRepository = SwiftDataTaskRepository(context: container.mainContext)
        self.projectRepository = SwiftDataProjectRepository(context: container.mainContext)
    }

    static func live() throws -> AppDependencies {
        AppDependencies(container: try PersistenceController.makeContainer())
    }
}
