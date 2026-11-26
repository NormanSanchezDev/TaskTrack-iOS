import Foundation

/**
 * Builds use cases and view models from `AppDependencies`.
 */
struct ViewModelFactory {
    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    static func preview() -> ViewModelFactory {
        ViewModelFactory(dependencies: .preview())
    }

    func ensureDefaultProject() async {
        _ = try? await makeEnsureDefaultProject()()
    }

    func makeTaskListViewModel() -> TaskListViewModel {
        TaskListViewModel(
            fetchTasks: makeFetchTasks(),
            fetchProjects: makeFetchProjects(),
            deleteTask: DeleteTaskUseCase(repository: dependencies.taskRepository)
        )
    }

    func makeTaskFormViewModel(taskID: UUID?, projectID: UUID?) -> TaskFormViewModel {
        TaskFormViewModel(
            taskID: taskID,
            initialProjectID: projectID,
            fetchTasks: makeFetchTasks(),
            fetchProjects: makeFetchProjects(),
            ensureDefaultProject: makeEnsureDefaultProject(),
            saveTask: SaveTaskUseCase(
                taskRepository: dependencies.taskRepository,
                projectRepository: dependencies.projectRepository
            )
        )
    }

    func makeProjectListViewModel() -> ProjectListViewModel {
        ProjectListViewModel(
            fetchProjects: makeFetchProjects(),
            ensureDefaultProject: makeEnsureDefaultProject(),
            deleteProject: DeleteProjectUseCase(repository: dependencies.projectRepository)
        )
    }

    func makeProjectDetailViewModel(projectID: UUID) -> ProjectDetailViewModel {
        ProjectDetailViewModel(
            projectID: projectID,
            fetchProjects: makeFetchProjects(),
            fetchTasks: makeFetchTasks(),
            deleteTask: DeleteTaskUseCase(repository: dependencies.taskRepository)
        )
    }

    func makeProjectFormViewModel(projectID: UUID?) -> ProjectFormViewModel {
        ProjectFormViewModel(
            projectID: projectID,
            fetchProjects: makeFetchProjects(),
            saveProject: SaveProjectUseCase(repository: dependencies.projectRepository)
        )
    }

    private func makeFetchTasks() -> FetchTasksUseCase {
        FetchTasksUseCase(repository: dependencies.taskRepository)
    }

    private func makeFetchProjects() -> FetchProjectsUseCase {
        FetchProjectsUseCase(
            projectRepository: dependencies.projectRepository,
            taskRepository: dependencies.taskRepository
        )
    }

    private func makeEnsureDefaultProject() -> EnsureDefaultProjectUseCase {
        EnsureDefaultProjectUseCase(repository: dependencies.projectRepository)
    }
}
