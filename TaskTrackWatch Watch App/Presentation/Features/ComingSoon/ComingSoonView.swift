import SwiftUI

/**
 * Placeholder for features that are not built yet.
 */
struct ComingSoonView: View {
    let title: String
    let systemImage: String

    var body: some View {
        ContentUnavailableView(
            "Coming Soon",
            systemImage: systemImage,
            description: Text("\(title) is on its way.")
        )
        .navigationTitle(title)
    }
}

#Preview {
    NavigationStack {
        ComingSoonView(title: "Pomodoro", systemImage: "timer")
    }
}
