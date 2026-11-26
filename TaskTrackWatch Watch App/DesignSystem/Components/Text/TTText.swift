import SwiftUI

public enum TTTextType {
    case title
    case description
    case body
    case caption
}

public struct TTTextModel {
    public var text: String
    public var type: TTTextType

    public init(text: String, type: TTTextType) {
        self.text = text
        self.type = type
    }
}

public struct TTText: View {

    @Environment(\.ttTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private let model: TTTextModel

    public init(model: TTTextModel) {
        self.model = model
    }

    public var body: some View {
        let style = theme.typography.style(for: model.type)
        Text(model.text)
            .font(style.font)
            .fontWeight(style.weight)
            .foregroundStyle(color)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.8)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var color: Color {
        let palette = theme.palette(for: colorScheme)
        return switch model.type {
        case .title: palette.primary
        case .body: palette.textPrimary
        case .description: palette.textSecondary
        case .caption: palette.accent
        }
    }
}

#Preview("Dark") {
    TTTextPreview()
        .environment(\.colorScheme, .dark)
}

#Preview("Light") {
    TTTextPreview()
        .environment(\.colorScheme, .light)
}

private struct TTTextPreview: View {
    @Environment(\.ttTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 6) {
            TTText(model: .init(text: "Title", type: .title))
            TTText(model: .init(text: "Description", type: .description))
            TTText(model: .init(text: "Body", type: .body))
            TTText(model: .init(text: "Caption", type: .caption))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.palette(for: colorScheme).background)
    }
}
