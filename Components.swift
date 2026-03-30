import SwiftUI

// ── Badge ───────────────────────────────────────────────────
struct SafeBadge: View {
    var label: String
    var safety: SafetyLevel

    var body: some View {
        Text(label)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(safety.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(safety.bgColor)
            .cornerRadius(5)
    }
}

// ── Star Rating ─────────────────────────────────────────────
struct StarRating: View {
    var rating: Double
    var size: CGFloat = 13

    var body: some View {
        HStack(spacing: 1) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: Double(star) <= rating ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundColor(SafeEatColors.amber)
            }
        }
    }
}

// ── Choice Item (Onboarding) ────────────────────────────────
struct ChoiceItem: View {
    var label: String
    var description: String
    var emoji: String
    @Binding var isSelected: Bool
    var isRadio: Bool = false

    var body: some View {
        Button(action: { isSelected.toggle() }) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: isRadio ? 10 : 6)
                        .stroke(isSelected ? SafeEatColors.green : SafeEatColors.border, lineWidth: 1.5)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        RoundedRectangle(cornerRadius: isRadio ? 10 : 6)
                            .fill(SafeEatColors.green)
                            .frame(width: 22, height: 22)
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(SafeEatColors.textPrimary)
                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(SafeEatColors.textSecondary)
                }
                Spacer()
                Text(emoji)
                    .font(.system(size: 20))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? SafeEatColors.greenLight : SafeEatColors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? SafeEatColors.green : SafeEatColors.border, lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// ── Restaurant List Card ────────────────────────────────────
struct RestaurantCard: View {
    var restaurant: Restaurant

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(restaurant.emojiBackground)
                    .frame(width: 56, height: 56)
                Text(restaurant.emoji)
                    .font(.system(size: 26))
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(restaurant.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(SafeEatColors.textPrimary)
                HStack(spacing: 4) {
                    StarRating(rating: restaurant.rating, size: 11)
                    Text("(\(restaurant.reviewCount))")
                        .font(.system(size: 11))
                        .foregroundColor(SafeEatColors.textTertiary)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(restaurant.badges) { badge in
                            SafeBadge(label: badge.label, safety: badge.safety)
                        }
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                Text(restaurant.distance)
                    .font(.system(size: 11))
                    .foregroundColor(SafeEatColors.textTertiary)
                Circle()
                    .fill(restaurant.glutenSafety.color)
                    .frame(width: 10, height: 10)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(SafeEatColors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(SafeEatColors.border, lineWidth: 0.5)
                )
        )
    }
}

// ── Safety Row ──────────────────────────────────────────────
struct SafetyRow: View {
    var icon: String
    var label: String
    var description: String
    var safety: SafetyLevel

    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.system(size: 18))
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(SafeEatColors.textPrimary)
                Text(description)
                    .font(.system(size: 11))
                    .foregroundColor(SafeEatColors.textSecondary)
            }
            Spacer()
            Text(safety.label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(safety.color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(safety.bgColor)
                .cornerRadius(6)
        }
        .padding(12)
        .background(safety.bgColor.opacity(0.5))
    }
}

// ── Bottom Nav Bar ──────────────────────────────────────────
struct BottomNavBar: View {
    @Binding var selected: Int

    let items: [(icon: String, label: String)] = [
        ("map", "Karte"),
        ("list.bullet", "Liste"),
        ("bookmark", "Gespeichert"),
        ("person", "Profil")
    ]

    var body: some View {
        HStack {
            ForEach(0..<items.count, id: \.self) { i in
                Button(action: { selected = i }) {
                    VStack(spacing: 3) {
                        Image(systemName: selected == i ? items[i].icon + ".fill" : items[i].icon)
                            .font(.system(size: 20))
                            .foregroundColor(selected == i ? SafeEatColors.green : SafeEatColors.textTertiary)
                        Text(items[i].label)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(selected == i ? SafeEatColors.green : SafeEatColors.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 10)
        .padding(.bottom, 20)
        .background(
            SafeEatColors.surface
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(SafeEatColors.border),
                    alignment: .top
                )
        )
    }
}

// ── Green Button ────────────────────────────────────────────
struct GreenButton: View {
    var label: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(SafeEatColors.green)
                .cornerRadius(14)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// ── Section Header ──────────────────────────────────────────
struct SectionHeader: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(SafeEatColors.textTertiary)
            .tracking(0.8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
