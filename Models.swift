import SwiftUI

// ── Design Tokens ──────────────────────────────────────────
struct SafeEatColors {
    static let green        = Color(hex: "#2A6B4A")
    static let greenLight   = Color(hex: "#E8F3ED")
    static let greenMid     = Color(hex: "#4CAF7A")
    static let amber        = Color(hex: "#B5630A")
    static let amberLight   = Color(hex: "#FDF0E3")
    static let red          = Color(hex: "#C0392B")
    static let redLight     = Color(hex: "#FDECEA")
    static let surface      = Color(hex: "#FDFCFA")
    static let surface2     = Color(hex: "#F5F2ED")
    static let border       = Color(hex: "#E2DDD6")
    static let textPrimary  = Color(hex: "#1A1916")
    static let textSecondary = Color(hex: "#6B6760")
    static let textTertiary = Color(hex: "#A09C96")
}

// ── Models ─────────────────────────────────────────────────
enum SafetyLevel {
    case safe, warning, danger

    var color: Color {
        switch self {
        case .safe:    return SafeEatColors.green
        case .warning: return SafeEatColors.amber
        case .danger:  return SafeEatColors.red
        }
    }
    var bgColor: Color {
        switch self {
        case .safe:    return SafeEatColors.greenLight
        case .warning: return SafeEatColors.amberLight
        case .danger:  return SafeEatColors.redLight
        }
    }
    var label: String {
        switch self {
        case .safe:    return "Sicher ✓"
        case .warning: return "Prüfen"
        case .danger:  return "Risiko"
        }
    }
}

struct Intolerance: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var emoji: String
    var isSelected: Bool
}

struct Restaurant: Identifiable {
    let id = UUID()
    var name: String
    var cuisine: String
    var distance: String
    var rating: Double
    var reviewCount: Int
    var emoji: String
    var emojiBackground: Color
    var glutenSafety: SafetyLevel
    var lactoseSafety: SafetyLevel
    var badges: [Badge]
    var menuItems: [MenuItem]
    var reviews: [Review]
}

struct Badge: Identifiable {
    let id = UUID()
    var label: String
    var safety: SafetyLevel
}

struct MenuItem: Identifiable {
    let id = UUID()
    var name: String
    var tags: [String]
    var safety: SafetyLevel
}

struct Review: Identifiable {
    let id = UUID()
    var initials: String
    var name: String
    var condition: String
    var rating: Int
    var text: String
    var avatarColor: Color
}

// ── Sample Data ─────────────────────────────────────────────
extension Restaurant {
    static let sampleData: [Restaurant] = [
        Restaurant(
            name: "Grüner Teller",
            cuisine: "Österreichisch",
            distance: "0.3 km",
            rating: 4.0,
            reviewCount: 82,
            emoji: "🥗",
            emojiBackground: Color(hex: "#E8F0E8"),
            glutenSafety: .safe,
            lactoseSafety: .safe,
            badges: [
                Badge(label: "Dediziert GF", safety: .safe),
                Badge(label: "Laktosefrei", safety: .safe)
            ],
            menuItems: [
                MenuItem(name: "Wiener Schnitzel (GF)", tags: ["GF","LF"], safety: .safe),
                MenuItem(name: "Linsensuppe",           tags: ["GF","LF"], safety: .safe),
                MenuItem(name: "Kaiserschmarrn",        tags: ["Hafer"],   safety: .warning),
                MenuItem(name: "Gulasch",               tags: ["GF","LF"], safety: .safe)
            ],
            reviews: [
                Review(initials: "LM", name: "Lisa M.", condition: "Zöliakie", rating: 5,
                       text: "Personal super informiert, eigene GF Fritteuse! Endlich sorglos essen.",
                       avatarColor: SafeEatColors.greenLight),
                Review(initials: "TK", name: "Thomas K.", condition: "GF + Laktose", rating: 4,
                       text: "Tolle Auswahl, Kaiserschmarrn lieber meiden. Sonst super!",
                       avatarColor: SafeEatColors.amberLight)
            ]
        ),
        Restaurant(
            name: "Pasta Nostra",
            cuisine: "Italienisch",
            distance: "0.6 km",
            rating: 5.0,
            reviewCount: 41,
            emoji: "🍝",
            emojiBackground: Color(hex: "#FFF3E0"),
            glutenSafety: .safe,
            lactoseSafety: .warning,
            badges: [
                Badge(label: "GF Pasta", safety: .safe),
                Badge(label: "Laktose möglich", safety: .warning)
            ],
            menuItems: [
                MenuItem(name: "Spaghetti Pomodoro", tags: ["GF","LF"], safety: .safe),
                MenuItem(name: "Carbonara",           tags: ["GF","Laktose"], safety: .warning)
            ],
            reviews: []
        ),
        Restaurant(
            name: "Green Bowl",
            cuisine: "Vegan",
            distance: "0.7 km",
            rating: 4.0,
            reviewCount: 29,
            emoji: "🌱",
            emojiBackground: Color(hex: "#E8F5E9"),
            glutenSafety: .safe,
            lactoseSafety: .safe,
            badges: [
                Badge(label: "Dediziert GF", safety: .safe),
                Badge(label: "Vegan = LF", safety: .safe)
            ],
            menuItems: [],
            reviews: []
        ),
        Restaurant(
            name: "Café Rondo",
            cuisine: "Café",
            distance: "0.9 km",
            rating: 3.0,
            reviewCount: 17,
            emoji: "☕",
            emojiBackground: Color(hex: "#FFF8E1"),
            glutenSafety: .warning,
            lactoseSafety: .warning,
            badges: [
                Badge(label: "GF möglich", safety: .warning),
                Badge(label: "Kreuzverunr. mögl.", safety: .danger)
            ],
            menuItems: [],
            reviews: []
        ),
        Restaurant(
            name: "Zum Wirt",
            cuisine: "Österreichisch",
            distance: "1.1 km",
            rating: 4.0,
            reviewCount: 55,
            emoji: "🥩",
            emojiBackground: Color(hex: "#FCE4EC"),
            glutenSafety: .safe,
            lactoseSafety: .safe,
            badges: [
                Badge(label: "GF Optionen", safety: .safe),
                Badge(label: "Laktosefrei", safety: .safe)
            ],
            menuItems: [],
            reviews: []
        )
    ]
}

// ── Color Hex Extension ─────────────────────────────────────
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}
