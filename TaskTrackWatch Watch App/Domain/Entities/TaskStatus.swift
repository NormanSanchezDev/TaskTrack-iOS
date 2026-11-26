import Foundation

/**
 * Workflow state of a task.
 */
enum TaskStatus: String, CaseIterable, Identifiable, Sendable {
    case backlog
    case todo
    case inProgress
    case review
    case done

    var id: String { rawValue }

    var title: String {
        switch self {
        case .backlog: "Backlog"
        case .todo: "To do"
        case .inProgress: "In progress"
        case .review: "Review"
        case .done: "Done"
        }
    }

    var systemImage: String {
        switch self {
        case .backlog: "tray"
        case .todo: "circle"
        case .inProgress: "circle.lefthalf.filled"
        case .review: "eye"
        case .done: "checkmark.circle.fill"
        }
    }
}
