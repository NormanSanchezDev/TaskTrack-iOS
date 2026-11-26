import Foundation

/**
 * State for the list of projects, including delete confirmation.
 */
@Observable
final class ProjectListViewModel {
    private(set) var summaries: [ProjectSummary] = []
    private(set) var isLoading = false
    private(set) var errorMessage = ""
    private(set) var pendingDeletion: ProjectSummary?
    var isShowingError = false
    var isConfirmingDeletion = false

    private let fetchProjects: FetchProjectsUseCase
    private let ensureDefaultProject: EnsureDefaultProjectUseCase
    private let deleteProject: DeleteProjectUseCase

    init(
        fetchProjects: FetchProjectsUseCase,
        ensureDefaultProject: EnsureDefaultProjectUseCase,
        deleteProject: DeleteProjectUseCase
    ) {
        self.fetchProjects = fetchProjects
        self.ensureDefaultProject = ensureDefaultProject
        self.deleteProject = deleteProject
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await ensureDefaultProject()
            var result: [ProjectSummary] = []
            for project in try await fetchProjects() {
                let count = try await fetchProjects.taskCount(projectID: project.id)
                result.append(ProjectSummary(project: project, taskCount: count))
            }
            summaries = result
        } catch {
            present(error)
        }
    }

    func requestDeletion(of summary: ProjectSummary) {
        pendingDeletion = summary
        isConfirmingDeletion = true
    }

    func confirmDeletion() async {
        guard let pendingDeletion else { return }
        self.pendingDeletion = nil
        do {
            try await deleteProject(id: pendingDeletion.id)
            summaries.removeAll { $0.id == pendingDeletion.id }
        } catch {
            present(error)
        }
    }

    private func present(_ error: Error) {
        errorMessage = error.localizedDescription
        isShowingError = true
    }
}
