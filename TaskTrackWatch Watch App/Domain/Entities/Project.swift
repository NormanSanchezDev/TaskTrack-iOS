import Foundation

/**
 * Domain representation of a project that groups tasks.
 */
struct Project: Identifiable, Equatable, Hashable, Sendable {
    let id: UUID
    var name: String
    var colorHex: String
    let isDefault: Bool
    let createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        colorHex: String = ProjectColor.all[0],
        isDefault: Bool = false,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.isDefault = isDefault
        self.createdAt = createdAt
    }
}
