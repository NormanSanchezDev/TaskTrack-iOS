import Foundation
import SwiftData
import Testing
@testable import TaskTrackWatch_Watch_App

@MainActor
struct SwiftDataRepositoryTests {
    let container: ModelContainer
    let projects: SwiftDataProjectRepository
    let tasks: SwiftDataTaskRepository

    init() throws {
        container = try PersistenceController.makeContainer(inMemory: true)
        projects = SwiftDataProjectRepository(context: container.mainContext)
        tasks = SwiftDataTaskRepository(context: container.mainContext)
    }

    @Test func taskSaveIsUpsert() async throws {
        let project = Project(name: "Work")
        try await projects.save(project)

        var task = TaskItem(title: "Draft", status: .backlog, assignee: nil, projectID: project.id)
        try await tasks.save(task)
        task.title = "Final"
        task.status = .done
        try await tasks.save(task)

        let stored = try await tasks.fetchAll(projectID: nil)
        #expect(stored.count == 1)
        #expect(stored.first?.title == "Final")
        #expect(stored.first?.status == .done)
        #expect(stored.first?.assignee == nil)
    }

    @Test func fetchFiltersByProject() async throws {
        let work = Project(name: "Work")
        let home = Project(name: "Home")
        try await projects.save(work)
        try await projects.save(home)
        try await tasks.save(TaskItem(title: "A", projectID: work.id))
        try await tasks.save(TaskItem(title: "B", projectID: home.id))

        let workTasks = try await tasks.fetchAll(projectID: work.id)
        #expect(workTasks.map(\.title) == ["A"])
        #expect(try await tasks.count(projectID: home.id) == 1)
    }

    @Test func deletingProjectCascadesToTasks() async throws {
        let project = Project(name: "Temp")
        try await projects.save(project)
        try await tasks.save(TaskItem(title: "Gone", projectID: project.id))

        try await projects.delete(id: project.id)

        #expect(try await projects.fetch(id: project.id) == nil)
        #expect(try await tasks.fetchAll(projectID: nil).isEmpty)
    }
}
