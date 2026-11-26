import Foundation

/**
 * Converts between `ProjectEntity` and the `Project` domain model.
 */
enum ProjectMapper {
    static func toDomain(_ entity: ProjectEntity) -> Project {
        Project(
            id: entity.id,
            name: entity.name,
            colorHex: entity.colorHex,
            emoji: entity.emoji,
            isDefault: entity.isDefault,
            createdAt: entity.createdAt
        )
    }

    static func makeEntity(from project: Project) -> ProjectEntity {
        ProjectEntity(
            id: project.id,
            name: project.name,
            colorHex: project.colorHex,
            emoji: project.emoji,
            isDefault: project.isDefault,
            createdAt: project.createdAt
        )
    }

    static func apply(_ project: Project, to entity: ProjectEntity) {
        entity.name = project.name
        entity.colorHex = project.colorHex
        entity.emoji = project.emoji
    }
}
