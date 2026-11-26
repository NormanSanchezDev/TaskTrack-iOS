import SwiftUI

/**
 * Color tokens for one appearance (light or dark).
 */
public struct TTPalette: Sendable {
    public var primary: Color
    public var onPrimary: Color
    public var textPrimary: Color
    public var textSecondary: Color
    public var accent: Color
    public var background: Color

    public init(
        primary: Color,
        onPrimary: Color,
        textPrimary: Color,
        textSecondary: Color,
        accent: Color,
        background: Color
    ) {
        self.primary = primary
        self.onPrimary = onPrimary
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.accent = accent
        self.background = background
    }
}

/**
 * Font and weight pair used by a text type.
 */
public struct TTTextStyle: Sendable {
    public var font: Font
    public var weight: Font.Weight

    public init(font: Font, weight: Font.Weight) {
        self.font = font
        self.weight = weight
    }
}

/**
 * Typography tokens, one per `TTTextType`.
 */
public struct TTTypography: Sendable {
    public var title: TTTextStyle
    public var description: TTTextStyle
    public var body: TTTextStyle
    public var caption: TTTextStyle

    public init(title: TTTextStyle, description: TTTextStyle, body: TTTextStyle, caption: TTTextStyle) {
        self.title = title
        self.description = description
        self.body = body
        self.caption = caption
    }

    public func style(for type: TTTextType) -> TTTextStyle {
        switch type {
        case .title: title
        case .description: description
        case .body: body
        case .caption: caption
        }
    }
}

/**
 * Design system theme injected through the environment as `\.ttTheme`.
 * Components resolve the palette with the current `colorScheme`.
 */
public struct TTTheme: Sendable {
    public var light: TTPalette
    public var dark: TTPalette
    public var typography: TTTypography

    public init(light: TTPalette, dark: TTPalette, typography: TTTypography) {
        self.light = light
        self.dark = dark
        self.typography = typography
    }

    public func palette(for colorScheme: ColorScheme) -> TTPalette {
        colorScheme == .dark ? dark : light
    }
}

public extension TTTheme {
    static let standard = TTTheme(
        light: TTPalette(
            primary: Color(red: 0.00, green: 0.42, blue: 0.95),
            onPrimary: .white,
            textPrimary: Color(white: 0.08),
            textSecondary: Color(white: 0.38),
            accent: Color(red: 0.00, green: 0.42, blue: 0.95),
            background: .white
        ),
        dark: TTPalette(
            primary: Color(red: 0.30, green: 0.60, blue: 1.00),
            onPrimary: .white,
            textPrimary: .white,
            textSecondary: Color(white: 0.72),
            accent: Color(red: 0.45, green: 0.70, blue: 1.00),
            background: .black
        ),
        typography: TTTypography(
            title: TTTextStyle(font: .title3, weight: .bold),
            description: TTTextStyle(font: .footnote, weight: .regular),
            body: TTTextStyle(font: .body, weight: .medium),
            caption: TTTextStyle(font: .caption2, weight: .regular)
        )
    )
}

public extension EnvironmentValues {
    @Entry var ttTheme: TTTheme = .standard
}

public extension View {
    /**
     * Injects a custom theme into this view hierarchy.
     */
    func ttTheme(_ theme: TTTheme) -> some View {
        environment(\.ttTheme, theme)
    }
}
