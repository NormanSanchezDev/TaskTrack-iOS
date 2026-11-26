import Foundation
import Testing
@testable import TaskTrackWatch_Watch_App

@MainActor
struct UseCaseTests {
    let projects = FakeProjectRepository()
    let tasks = FakeTaskRepository()

    @Test func saveTaskRejectsBlankTitle() async throws {
        let inbox = try await EnsureDefaultProjectUseCase(repository: projects)()
        let save = SaveTaskUseCase(taskRepository: tasks, projectRepository: projects)

        await #expect(throws: DomainError.emptyName) {
            try await save(TaskItem(title: "   ", projectID: inbox.id))
        }
        #expect(tasks.tasks.isEmpty)
    }

    @Test func saveTaskTrimsTitleAndRequiresExistingProject() async throws {
        let inbox = try await EnsureDefaultProjectUseCase(repository: projects)()
        let save = SaveTaskUseCase(taskRepository: tasks, projectRepository: projects)

        try await save(TaskItem(title: "  Ship  ", projectID: inbox.id))
        #expect(tasks.tasks.values.first?.title == "Ship")

        await #expect(throws: DomainError.projectNotFound) {
            try await save(TaskItem(title: "Orphan", projectID: UUID()))
        }
    }

    @Test func ensureDefaultProjectIsIdempotent() async throws {
        let ensure = EnsureDefaultProjectUseCase(repository: projects)
        let first = try await ensure()
        let second = try await ensure()

        #expect(first.id == second.id)
        #expect(projects.projects.count == 1)
        #expect(first.isDefault)
    }

    @Test func defaultProjectCannotBeDeleted() async throws {
        let inbox = try await EnsureDefaultProjectUseCase(repository: projects)()

        await #expect(throws: DomainError.cannotDeleteDefaultProject) {
            try await DeleteProjectUseCase(repository: projects)(id: inbox.id)
        }
    }

    @Test func fetchProjectsListsDefaultFirst() async throws {
        try await projects.save(Project(name: "Alpha"))
        try await EnsureDefaultProjectUseCase(repository: projects)()

        let result = try await FetchProjectsUseCase(projectRepository: projects, taskRepository: tasks)()
        #expect(result.first?.isDefault == true)
        #expect(result.map(\.name) == ["Inbox", "Alpha"])
    }
}
