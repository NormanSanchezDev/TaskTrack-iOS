import CoreGraphics

/**
 * Shared sizing for every `TTButton` variant so they always match in width and height.
 */
enum TTButtonMetrics {
    static let minHeight: CGFloat = 44
    static let horizontalPadding: CGFloat = 12
    static let borderWidth: CGFloat = 2
    static let pressedScale: CGFloat = 0.96
    static let disabledOpacity: Double = 0.4
}
