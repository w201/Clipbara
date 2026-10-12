import SwiftUI

/// Derives card and panel sizes from the screen height so the shelf looks the
/// same relative to the display on a laptop and on a large monitor.
enum CardScale {
    /// Visible screen height (pt) at which cards keep their base size
    /// (14" MacBook, below the menu bar and above the Dock).
    static let referenceHeight: CGFloat = 900
    static let minimumFactor: CGFloat = 0.85
    static let maximumFactor: CGFloat = 1.45

    static let baseCardWidth: CGFloat = 218
    static let baseCardHeight: CGFloat = 188
    /// Card height plus the vertical breathing room around the row.
    static let baseCardAreaHeight: CGFloat = 214
    /// Navigation bar, search and other fixed chrome above the cards.
    static let chromeHeight: CGFloat = 66

    static func factor(forScreenHeight height: CGFloat) -> CGFloat {
        clamp(height / referenceHeight)
    }

    static func panelHeight(forScreenHeight height: CGFloat) -> CGFloat {
        chromeHeight + baseCardAreaHeight * factor(forScreenHeight: height)
    }

    /// Inverse of `panelHeight`: recovers the factor from the height the card
    /// row was given, so the grids stay in step with the panel.
    static func factor(forCardAreaHeight height: CGFloat) -> CGFloat {
        clamp(height / baseCardAreaHeight)
    }

    private static func clamp(_ factor: CGFloat) -> CGFloat {
        min(max(factor, minimumFactor), maximumFactor)
    }
}

private struct ScaledCard: ViewModifier {
    let scale: CGFloat

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: .topLeading)
            .frame(
                width: CardScale.baseCardWidth * scale,
                height: CardScale.baseCardHeight * scale,
                alignment: .topLeading
            )
    }
}

extension View {
    /// Lays the card out at its base size, then scales it uniformly.
    func scaledCard(_ scale: CGFloat) -> some View {
        modifier(ScaledCard(scale: scale))
    }
}
