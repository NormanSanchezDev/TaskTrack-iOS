import SwiftUI

public enum TTButtonType {
    case filled
    case outlined
    case text
}

public struct TTButtonModel {
    public var action: () -> Void
    public var trailingIcon: String?
    public var text: String
    public var type: TTButtonType

    public init(
        text: String,
        trailingIcon: String? = nil,
        type: TTButtonType = .filled,
        action: @escaping () -> Void
    ) {
        self.action = action
        self.trailingIcon = trailingIcon
        self.type = type
        self.text = text
    }
}

public struct TTButton: View {

    @Environment(\.ttTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private let model: TTButtonModel

    public init(model: TTButtonModel) {
        self.model = model
    }

    public var body: some View {
        let palette = theme.palette(for: colorScheme)
        let button = Button(action: model.action) { label }

        switch model.type {
        case .filled:
            button
                .buttonStyle(.glassProminent)
                .tint(palette.primary)
                .foregroundStyle(palette.onPrimary)
        case .outlined:
            button
                .buttonStyle(TTOutlinedButtonStyle(color: palette.primary))
        case .text:
            button
                .buttonStyle(.plain)
                .foregroundStyle(palette.primary)
                .frame(minHeight: TTButtonMetrics.minHeight)
        }
    }

    private var label: some View {
        HStack(spacing: 6) {
            Text(model.text)
                .fontWeight(.semibold)
            if let trailingIcon = model.trailingIcon {
                Image(systemName: trailingIcon)
                    .fontWeight(.bold)
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .frame(maxWidth: .infinity)
    }
}

private enum TTButtonMetrics {
    static let minHeight: CGFloat = 44
    static let borderWidth: CGFloat = 2
}

/**
 * Outlined capsule. Uses `strokeBorder` so the line is drawn inside
 * the bounds and never gets clipped by the screen or container edges.
 */
private struct TTOutlinedButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(color)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, minHeight: TTButtonMetrics.minHeight)
            .background {
                Capsule()
                    .fill(color.opacity(configuration.isPressed ? 0.25 : 0.001))
            }
            .overlay {
                Capsule()
                    .strokeBorder(color, lineWidth: TTButtonMetrics.borderWidth)
            }
            .contentShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.snappy(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview("Dark") {
    TTButtonPreview()
        .environment(\.colorScheme, .dark)
}

#Preview("Light") {
    TTButtonPreview()
        .environment(\.colorScheme, .light)
}

private struct TTButtonPreview: View {
    @Environment(\.ttTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 8) {
            TTButton(model: .init(text: "Filled", trailingIcon: "plus", type: .filled) {})
            TTButton(model: .init(text: "Outlined", trailingIcon: "list.bullet", type: .outlined) {})
            TTButton(model: .init(text: "Text", type: .text) {})
        }
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.palette(for: colorScheme).background)
    }
}
