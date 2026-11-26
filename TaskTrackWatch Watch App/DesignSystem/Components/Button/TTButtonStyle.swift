import SwiftUI

/**
 * Single style for all `TTButton` variants. Every variant shares the same
 * frame, so filled, outlined and text buttons always have equal width.
 * Filled uses tinted interactive Liquid Glass; outlined uses `strokeBorder`
 * so the line is drawn inside the bounds and never gets clipped.
 */
struct TTButtonStyle: ButtonStyle {
    let type: TTButtonType
    let palette: TTPalette

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        let content = configuration.label
            .foregroundStyle(foreground)
            .padding(.horizontal, TTButtonMetrics.horizontalPadding)
            .frame(maxWidth: .infinity, minHeight: TTButtonMetrics.minHeight)

        decorated(content, isPressed: configuration.isPressed)
            .contentShape(Capsule())
            .opacity(isEnabled ? 1 : TTButtonMetrics.disabledOpacity)
            .scaleEffect(configuration.isPressed ? TTButtonMetrics.pressedScale : 1)
            .animation(.snappy(duration: 0.15), value: configuration.isPressed)
    }

    private var foreground: Color {
        type == .filled ? palette.onPrimary : palette.primary
    }

    @ViewBuilder
    private func decorated(_ content: some View, isPressed: Bool) -> some View {
        switch type {
        case .filled:
            content
                .glassEffect(.regular.tint(palette.primary).interactive(), in: Capsule())
        case .outlined:
            content
                .background {
                    Capsule().fill(palette.primary.opacity(isPressed ? 0.25 : 0.001))
                }
                .overlay {
                    Capsule().strokeBorder(palette.primary, lineWidth: TTButtonMetrics.borderWidth)
                }
        case .text:
            content
                .background {
                    Capsule().fill(palette.primary.opacity(isPressed ? 0.15 : 0.001))
                }
        }
    }
}
