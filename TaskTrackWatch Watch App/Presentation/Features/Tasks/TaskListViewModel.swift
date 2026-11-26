import Foundation

/**
 * State for the list of all tasks.
 */
@Observable
final class TaskListViewModel {
    private(set) var tasks: [TaskItem] = []
    private(set) var projects: [UUID: Project] = [:]
    private(set) var isLoading = false
    private(set) var errorMessage = ""
    var isShowingError = false

    private let fetchTasks: FetchTasksUseCase
    private let fetchProjects: FetchProjectsUseCase
    private let deleteTask: DeleteTaskUseCase

    init(fetchTasks: FetchTasksUseCase, fetchProjects: FetchProjectsUseCase, deleteTask: DeleteTaskUseCase) {
        self.fetchTasks = fetchTasks
        self.fetchProjects = fetchProjects
        self.deleteTask = deleteTask
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            tasks = try await fetchTasks()
            projects = Dictionary(uniqueKeysWithValues: try await fetchProjects().map { ($0.id, $0) })
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
