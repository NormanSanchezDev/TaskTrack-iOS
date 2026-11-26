import Foundation

/**
 * Fixed palette of hex colors a project can use, with display names.
 */
enum ProjectColor {
    static let all: [String] = ["#0A6CF2", "#34C759", "#FF9500", "#FF2D55", "#AF52DE", "#5AC8FA"]

    static func name(for hex: String) -> String {
        switch hex {
        case "#0A6CF2": "Blue"
        case "#34C759": "Green"
        case "#FF9500": "Orange"
        case "#FF2D55": "Pink"
        case "#AF52DE": "Purple"
        case "#5AC8FA": "Teal"
        default: "Custom"
        }
    }
}
