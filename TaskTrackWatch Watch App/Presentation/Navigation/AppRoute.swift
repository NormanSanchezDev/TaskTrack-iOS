import Foundation

/**
 * Destinations reachable from the root `NavigationStack`.
 */
enum AppRoute: Hashable {
    case taskList
    case taskForm(taskID: UUID?, projectID: UUID?)
    case projectList
    case projectDetail(projectID: UUID)
    case projectForm(projectID: UUID?)
    case pomodoro
    case settings
}
