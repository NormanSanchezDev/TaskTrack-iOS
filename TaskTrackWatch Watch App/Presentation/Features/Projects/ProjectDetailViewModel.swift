import Foundation

/**
 * State for one project and its tasks.
 */
@Observable
final class ProjectDetailViewModel {
    let projectID: UUID
    private(set) var project: Project?
    private(set) var tasks: [TaskItem] = []
    private(set) var isLoading = false
    private(set) var errorMessage = ""
    var isShowingError = false

    private let fetchProjects: FetchProjectsUseCase
    private let fetchTasks: FetchTasksUseCase
    private let deleteTask: DeleteTaskUseCase

    init(
        projectID: UUID,
        fetchProjects: FetchProjectsUseCase,
        fetchTasks: FetchTasksUseCase,
        deleteTask: DeleteTaskUseCase
    ) {
        self.projectID = projectID
        self.fetchProjects = fetchProjects
        self.fetchTasks = fetchTasks
        self.deleteTask = deleteTask
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            project = try await fetchProjects.one(id: projectID)
            tasks = try await fetchTasks(projectID: projectID)
        } catch {
            present(error)
        }
    }

    func delete(_ task: TaskItem) async {
        do {
            try await deleteTask(id: task.id)
            tasks.removeAll { $0.id == task.id }
        } catch {
            present(error)
        }
    }

    private func present(_ error: Error) {
        errorMessage = error.localizedDescription
        isShowingError = true
    }
}
