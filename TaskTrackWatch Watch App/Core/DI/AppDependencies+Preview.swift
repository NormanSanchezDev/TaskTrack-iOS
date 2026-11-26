import Foundation
import SwiftData

extension AppDependencies {
    /**
     * In-memory dependencies seeded with sample data, for previews only.
     */
    static func preview() -> AppDependencies {
        do {
            let container = try PersistenceController.makeContainer(inMemory: true)
            seed(container.mainContext)
            return AppDependencies(container: container)
        } catch {
            preconditionFailure("Preview container failed: \(error)")
        }
    }

    private static func seed(_ context: ModelContext) {
        let inbox = ProjectEntity(
            id: UUID(),
            name: EnsureDefaultProjectUseCase.defaultName,
            colorHex: ProjectColor.all[0],
            emoji: ProjectEmoji.all[0],
            isDefault: true,
            createdAt: .now
        )
        let personal = ProjectEntity(
            id: UUID(),
            name: "Personal",
            colorHex: ProjectColor.all[2],
            emoji: ProjectEmoji.all[2],
            isDefault: false,
            createdAt: .now
        )
        context.insert(inbox)
        context.insert(personal)

        let samples: [(String, TaskStatus, Int, ProjectEntity)] = [
            ("Design review", .review, 1, inbox),
            ("Buy groceries", .todo, 0, personal),
            ("Ship watch app", .inProgress, 3, inbox)
        ]
        for (title, status, days, project) in samples {
            context.insert(
                TaskEntity(
                    id: UUID(),
                    title: title,
                    statusRaw: status.rawValue,
                    dueDate: Calendar.current.date(byAdding: .day, value: days, to: .now) ?? .now,
                    assignee: Assignee.defaultName,
                    createdAt: .now,
                    project: project
                )
            )
        }
        try? context.save()
    }
}
