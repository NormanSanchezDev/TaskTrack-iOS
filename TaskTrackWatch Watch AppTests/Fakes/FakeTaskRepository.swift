import Foundation
@testable import TaskTrackWatch_Watch_App

@MainActor
final class FakeTaskRepository: TaskRepository {
    var tasks: [UUID: TaskItem] = [:]

    func fetchAll(projectID: UUID?) async throws -> [TaskItem] {
        tasks.values.filter { projectID == nil || $0.projectID == projectID }
    }

    func fetch(id: UUID) async throws -> TaskItem? { tasks[id] }
    func save(_ task: TaskItem) async throws { tasks[task.id] = task }
    func delete(id: UUID) async throws { tasks[id] = nil }

    func count(projectID: UUID) async throws -> Int {
        tasks.values.filter { $0.projectID == projectID }.count
    }
}
