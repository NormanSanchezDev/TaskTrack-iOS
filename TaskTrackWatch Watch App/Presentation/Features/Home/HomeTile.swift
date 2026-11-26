import SwiftUI

/**
 * Square Liquid Glass tile with an icon above its title.
 */
struct HomeTile: View {
    let destination: HomeDestination
    let action: () -> Void

    @Environment(\.ttTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private let shape = RoundedRectangle(cornerRadius: 18, style: .continuous)

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: destination.systemImage)
                    .font(.title3)
                    .foregroundStyle(theme.palette(for: colorScheme).primary)
                    .accessibilityHidden(true)

                Text(destination.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity, minHeight: 64)
            .contentShape(shape)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: shape)
    }
}

#Preview {
    HomeTile(destination: .pomodoro) {}
        .padding()
}
