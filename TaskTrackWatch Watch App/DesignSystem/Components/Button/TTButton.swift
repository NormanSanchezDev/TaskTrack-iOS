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
        Button(action: model.action) { label }
            .buttonStyle(TTButtonStyle(type: model.type, palette: theme.palette(for: colorScheme)))
    }

    private var label: some View {
        HStack(spacing: 6) {
            Text(model.text)
                .fontWeight(.semibold)
            if let trailingIcon = model.trailingIcon {
                Image(systemName: trailingIcon)
                    .fontWeight(.bold)
                    .accessibilityHidden(true)
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.8)
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
            TTButton(model: .init(text: "Disabled", type: .filled) {})
                .disabled(true)
        }
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.palette(for: colorScheme).background)
    }
}
