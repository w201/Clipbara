import CoreGraphics

/// User scale for the whole Quick Look bubble (text, icons, controls, size).
enum QuickLookScaleSetting {
    static let defaultsKey = "quickLookScale"
    static let defaultValue = 1.0
    static let range = 0.6...1.4
    static let step = 0.05

    static func clamped(_ value: Double) -> CGFloat {
        CGFloat(min(max(value, range.lowerBound), range.upperBound))
    }
}
