import SwiftUI

/**
 * Shown when the local store can't be opened.
 */
struct StartupErrorView: View {
    let message: String

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.title2)
                    .foregroundStyle(.orange)
                    .accessibilityHidden(true)
                TTText(model: .init(text: "Storage unavailable", type: .body, alignment: .center))
                TTText(model: .init(text: message, type: .caption, alignment: .center))
            }
        }
    }
}

#Preview {
    StartupErrorView(message: "The store could not be opened.")
}
