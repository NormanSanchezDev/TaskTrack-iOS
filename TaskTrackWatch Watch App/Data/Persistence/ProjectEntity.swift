import Foundation
import SwiftData

/**
 * SwiftData storage model for a project. Deleting it cascades to its tasks.
 */
@Model
final class ProjectEntity {
    @Attribute(.unique) var id: UUID
    var name: String
    var colorHex: String
    var emoji: String = ProjectEmoji.defaultValue
    var isDefault: Bool
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \TaskEntity.project)
    var tasks: [TaskEntity] = []

    init(id: UUID, name: String, colorHex: String, emoji: String, isDefault: Bool, createdAt: Date) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.emoji = emoji
        self.isDefault = isDefault
        self.createdAt = createdAt
    }
}
