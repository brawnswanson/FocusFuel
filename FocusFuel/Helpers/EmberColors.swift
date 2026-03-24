import SwiftUI

// MARK: - FocusFuel Ember Color System
//
// Usage:
//   Text("Hello").foregroundStyle(Color.textPrimary)
//   RoundedRectangle(cornerRadius: 12).fill(Color.surface)
//   Circle().fill(Color.Tier.boss.default)

/*extension Color {

    // MARK: Surfaces
    static let appBackground  = Color("appBackground")   // #F7F3EE — screen/page fill
    static let surface        = Color("surface")         // #FFFFFF — cards, sheets, modals
    static let surfaceSubtle  = Color("surfaceSubtle")   // #EDE9E3 — input bg, dividers, pressed states
    static let surfaceInverse = Color("surfaceInverse")  // #2C2C2A — toasts, tooltips, dark sheets

    // MARK: Typography
    static let textPrimary    = Color("textPrimary")     // #2C2C2A — headings, task titles, labels
    static let textSecondary  = Color("textSecondary")   // #5F5E5A — subtitles, metadata, descriptions
    static let textTertiary   = Color("textTertiary")    // #888780 — placeholders, hints, disabled
    static let textInverse    = Color("textInverse")     // #F7F3EE — text on dark surfaces

    // MARK: Accent / Fuel (purple)
    static let accentDefault  = Color("accentDefault")   // #534AB7 — primary buttons, links, Fuel counter
    static let accentLight    = Color("accentLight")     // #7F77DD — hover/pressed highlights
    static let accentDark     = Color("accentDark")      // #3C3489 — deep pressed state, focus rings
    static let accentSubtle   = Color("accentSubtle")    // #EEEDFE — tinted backgrounds, badges
    static let accentText     = Color("accentText")      // #26215C — text on accentSubtle backgrounds

    // MARK: Borders
    static let borderSubtle   = Color("borderSubtle")    // #D3D1C7 — default card/input border
    static let borderDefault  = Color("borderDefault")   // #B4B2A9 — emphasis border
    static let borderStrong   = Color("borderStrong")    // #888780 — focus rings, active borders
} */

// MARK: - Tier Colors

extension Color {

    enum Tier {
        case boss
        case medium
        case quick

        /// The saturated foreground — dot, icon, progress fill
        var `default`: Color {
            switch self {
            case .boss:   return Color("bossDefault")    // #D85A30
            case .medium: return Color("mediumDefault")  // #BA7517
            case .quick:  return Color("quickDefault")   // #3B6D11
            }
        }

        /// Darker shade — badge text, pressed state
        var dark: Color {
            switch self {
            case .boss:   return Color("bossDark")       // #993C1D
            case .medium: return Color("mediumDark")     // #854F0B
            case .quick:  return Color("quickDark")      // #27500A
            }
        }

        /// Text colour for use on the subtle background
        var text: Color {
            switch self {
            case .boss:   return Color("bossText")       // #712B13
            case .medium: return Color("mediumText")     // #633806
            case .quick:  return Color("quickText")      // #27500A
            }
        }

        /// Tinted background — chip, badge, row highlight
        var subtle: Color {
            switch self {
            case .boss:   return Color("bossSubtle")     // #FAECE7
            case .medium: return Color("mediumSubtle")   // #FAEEDA
            case .quick:  return Color("quickSubtle")    // #EAF3DE
            }
        }

        /// Display name for the tier
        var label: String {
            switch self {
            case .boss:   return "Boss"
            case .medium: return "Medium"
            case .quick:  return "Quick Win"
            }
        }
    }
}

// MARK: - Ramps
// Full 7-stop ramps for use in animations, gradients, or custom drawing.
// Index 0 = darkest (900), index 6 = lightest (50).

extension Color {

    enum Ramp {

        static let boss: [Color] = [
            Color(hex: 0x4A1B0C), // 900
            Color(hex: 0x712B13), // 800
            Color(hex: 0x993C1D), // 600
            Color(hex: 0xD85A30), // 400 ← bossDefault
            Color(hex: 0xF0997B), // 200
            Color(hex: 0xF5C4B3), // 100
            Color(hex: 0xFAECE7), // 50  ← bossSubtle
        ]

        static let medium: [Color] = [
            Color(hex: 0x412402), // 900
            Color(hex: 0x633806), // 800
            Color(hex: 0x854F0B), // 600
            Color(hex: 0xBA7517), // 400 ← mediumDefault
            Color(hex: 0xEF9F27), // 200
            Color(hex: 0xFAC775), // 100
            Color(hex: 0xFAEEDA), // 50  ← mediumSubtle
        ]

        static let quick: [Color] = [
            Color(hex: 0x173404), // 900
            Color(hex: 0x27500A), // 800
            Color(hex: 0x3B6D11), // 600 ← quickDefault
            Color(hex: 0x639922), // 400
            Color(hex: 0x97C459), // 200
            Color(hex: 0xC0DD97), // 100
            Color(hex: 0xEAF3DE), // 50  ← quickSubtle
        ]

        static let accent: [Color] = [
            Color(hex: 0x26215C), // 900 ← accentText
            Color(hex: 0x3C3489), // 800 ← accentDark
            Color(hex: 0x534AB7), // 600 ← accentDefault
            Color(hex: 0x7F77DD), // 400 ← accentLight
            Color(hex: 0xAFA9EC), // 200
            Color(hex: 0xCECBF6), // 100
            Color(hex: 0xEEEDFE), // 50  ← accentSubtle
        ]

        static let neutral: [Color] = [
            Color(hex: 0x2C2C2A), // 900 ← textPrimary
            Color(hex: 0x444441), // 800
            Color(hex: 0x5F5E5A), // 600 ← textSecondary
            Color(hex: 0x888780), // 400 ← textTertiary / borderStrong
            Color(hex: 0xB4B2A9), // 200 ← borderDefault
            Color(hex: 0xD3D1C7), // 100 ← borderSubtle
            Color(hex: 0xF1EFE8), // 50
        ]
    }
}

// MARK: - Hex Initialiser (private utility)

private extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8)  & 0xFF) / 255
        let b = Double(hex         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
