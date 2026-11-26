import Foundation

/**
 * Business rule violations raised by use cases.
 */
enum DomainError: LocalizedError, Equatable {
    case emptyName
    case projectNotFound
    case cannotDeleteDefaultProject

    var errorDescription: String? {
        switch self {
        case .emptyName: "Name can't be empty."
        case .projectNotFound: "Project not found."
        case .cannotDeleteDefaultProject: "Inbox can't be deleted."
        }
    }
}
