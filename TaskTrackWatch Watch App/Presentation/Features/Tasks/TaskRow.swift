import SwiftUI

/**
 * One task: status icon tinted with the project color, title and due date.
 */
struct TaskRow: View {
    let task: TaskItem
    let project: Project?

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: task.status.systemImage)
                .foregroundStyle(project.map { Color(hex: $0.colorHex) } ?? .accentColor)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                TTText(model: .init(text: task.title, type: .body))
                TTText(model: .init(text: subtitle, type: .description))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityValue(task.status.title)
    }

    private var subtitle: String {
        let date = task.dueDate.formatted(.dateTime.day().month(.abbreviated))
        guard let project else { return date }
        return "\(date) · \(project.name)"
    }
}
