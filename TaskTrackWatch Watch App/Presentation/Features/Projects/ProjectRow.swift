import SwiftUI

/**
 * One project: color dot, name and task count.
 */
struct ProjectRow: View {
    let summary: ProjectSummary

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color(hex: summary.project.colorHex))
                .frame(width: 10, height: 10)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                TTText(model: .init(text: summary.project.name, type: .body))
                TTText(model: .init(text: taskCountText, type: .description))
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var taskCountText: String {
        summary.taskCount == 1 ? "1 task" : "\(summary.taskCount) tasks"
    }
}
