import Foundation

/**
 * State for creating or editing a project.
 */
@Observable
final class ProjectFormViewModel {
    var name = ""
    var colorHex = ProjectColor.all[0]
    var emoji = ProjectEmoji.defaultValue
    var isShowingError = false
    private(set) var isSaving = false
    private(set) var errorMessage = ""

    var isEditing: Bool { projectID != nil }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSaving
    }

    private let projectID: UUID?
    private let fetchProjects: FetchProjectsUseCase
    private let saveProject: SaveProjectUseCase
    private var existing: Project?
    private var hasLoaded = false

    init(projectID: UUID?, fetchProjects: FetchProjectsUseCase, saveProject: SaveProjectUseCase) {
        self.projectID = projectID
        self.fetchProjects = fetchProjects
        self.saveProject = saveProject
    }

    /**
     * Loads once so returning from the color picker keeps edits.
     */
    func load() async {
        guard !hasLoaded, let projectID else { return }
        hasLoaded = true
        do {
            guard let project = try await fetchProjects.one(id: projectID) else {
                throw DomainError.projectNotFound
            }
            existing = project
            name = project.name
            colorHex = project.colorHex
            emoji = project.emoji
        } catch {
            present(error)
        }
    }

    func save() async -> Bool {
        isSaving = true
        defer { isSaving = false }
        let project = Project(
            id: existing?.id ?? UUID(),
            name: name,
            colorHex: colorHex,
            emoji: emoji,
            isDefault: existing?.isDefault ?? false,
            createdAt: existing?.createdAt ?? .now
        )
        do {
            try await saveProject(project)
            return true
        } catch {
            present(error)
            return false
        }
    }

    private func present(_ error: Error) {
        errorMessage = error.localizedDescription
        isShowingError = true
    }
}
