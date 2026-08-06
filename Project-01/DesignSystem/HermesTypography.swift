import SwiftUI

struct HermesFont {
    enum Style {
        case windowTitle
        case sidebarSection
        case sidebarRow
        case chatBody
        case codeBlock
        case composerText
        case composerControls
        case toolCallTitle
        case caption
        case badge
    }
    
    static func font(_ style: Style) -> Font {
        switch style {
        case .windowTitle:
            return .system(size: 20, weight: .semibold, design: .default)
        case .sidebarSection:
            return .system(size: 13, weight: .medium, design: .default)
        case .sidebarRow:
            return .system(size: 14, weight: .regular, design: .default)
        case .chatBody:
            return .system(size: 14, weight: .regular, design: .default)
        case .codeBlock:
            return .system(size: 13, weight: .regular, design: .monospaced)
        case .composerText:
            return .system(size: 15, weight: .regular, design: .default)
        case .composerControls:
            return .system(size: 12, weight: .medium, design: .default)
        case .toolCallTitle:
            return .system(size: 13, weight: .semibold, design: .default)
        case .caption:
            return .system(size: 11, weight: .light, design: .default)
        case .badge:
            return .system(size: 11, weight: .medium, design: .rounded)
        }
    }
}

extension View {
    func hermesFont(_ style: HermesFont.Style) -> some View {
        self.font(HermesFont.font(style))
    }
}
