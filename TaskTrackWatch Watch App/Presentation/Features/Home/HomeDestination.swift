import Foundation

/**
 * Tiles shown in the home grid, in display order.
 */
enum HomeDestination: CaseIterable, Identifiable {
    case tasks
    case pomodoro
    case projects
    case settings

    var id: Self { self }

    var title: String {
        switch self {
        case .tasks: "Tasks"
        case .pomodoro: "Pomodoro"
        case .projects: "Projects"
        case .settings: "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .tasks: "checklist"
        case .pomodoro: "timer"
        case .projects: "folder"
        case .settings: "gearshape"
        }
    }

    var route: AppRoute {
        switch self {
        case .tasks: .taskList
        case .pomodoro: .pomodoro
        case .projects: .projectList
        case .settings: .settings
        }
    }
}
