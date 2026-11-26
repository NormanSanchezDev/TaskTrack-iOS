import Foundation

/**
 * State for creating or editing a task.
 */
@Observable
final class TaskFormViewModel {
    var title = ""
    var status: TaskStatus = .todo
    var dueDate: Date = .now
    var isAssigned = true
    var projectID: UUID?
    var isShowingError = false
    private(set) var projects: [Project] = []
    private(set) var isSaving = false
    private(set) var errorMessage = ""

    let assigneeName = Assignee.defaultName

    var isEditing: Bool { taskID != nil }

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && projectID != nil && !isSaving
    }

    private let taskID: UUID?
    private let initialProjectID: UUID?
    private let fetchTasks: FetchTasksUseCase
    private let fetchProjects: FetchProjectsUseCase
    private let ensureDefaultProject: EnsureDefaultProjectUseCase
    private let saveTask: SaveTaskUseCase
    private var createdAt: Date = .now
    private var hasLoaded = false

    init(
        taskID: UUID?,
        initialProjectID: UUID?,
        fetchTasks: FetchTasksUseCase,
        fetchProjects: FetchProjectsUseCase,
        ensureDefaultProject: EnsureDefaultProjectUseCase,
        saveTask: SaveTaskUseCase
    ) {
        self.taskID = taskID
        self.initialProjectID = initialProjectID
        self.fetchTasks = fetchTasks
        self.fetchProjects = fetchProjects
        self.ensureDefaultProject = ensureDefaultProject
        self.saveTask = saveTask
    }

    /**
     * Loads once. Pickers push sub-screens on watchOS, so `.task` runs again
     * when returning and must not reset what the user already entered.
     */
    func load() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        do {
            let inbox = try await ensureDefaultProject()
            projects = try await fetchProjects()
            if let taskID, let task = try await fetchTasks.one(id: taskID) {
                apply(task)
            } else {
                projectID = initialProjectID ?? inbox.id
            }
        } catch {
            present(error)
        }
    }

    func save() async -> Bool {
        guard let projectID else { return false }
        isSaving = true
        defer { isSaving = false }
        let task = TaskItem(
            id: taskID ?? UUID(),
            title: title,
            status: status,
            dueDate: dueDate,
            assignee: isAssigned ? assigneeName : nil,
            projectID: projectID,
            createdAt: createdAt
        )
        do {
            try await saveTask(task)
            return true
        } catch {
            present(error)
            return false
        }
    }

    private func apply(_ task: TaskItem) {
        title = task.title
        status = task.status
        dueDate = task.dueDate
        isAssigned = task.assignee != nil
        projectID = task.projectID
        createdAt = task.createdAt
    }

    private func present(_ error: Error) {
        errorMessage = error.localizedDescription
        isShowingError = true
    }
}
