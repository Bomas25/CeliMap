import SwiftUI

// ── Screen 6: Restaurant Detail ─────────────────────────────
struct RestaurantDetailView: View {
    var restaurant: Restaurant
    var onBack: () -> Void

    @State private var isSaved = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {

                    // Hero image
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#C8E6C9"), Color(hex: "#A5D6A7")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 200)
                            .overlay(
                                Text(restaurant.emoji)
                                    .font(.system(size: 64))
                            )

                        HStack {
                            Button(action: onBack) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(SafeEatColors.textPrimary)
                                    .frame(width: 36, height: 36)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(10)
                            }
                            Spacer()
                            Button(action: { isSaved.toggle() }) {
                                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                                    .font(.system(size: 15))
                                    .foregroundColor(SafeEatColors.textPrimary)
                                    .frame(width: 36, height: 36)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 56)
                    }

                    // Header info
                    VStack(alignment: .leading, spacing: 6) {
                        Text(restaurant.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(SafeEatColors.textPrimary)
                        Text("\(restaurant.cuisine) · \(restaurant.distance) · Di–So 11:30–22:00")
                            .font(.system(size: 13))
                            .foregroundColor(SafeEatColors.textSecondary)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(restaurant.badges) { b in
                                    SafeBadge(label: b.label, safety: b.safety)
                                }
                                HStack(spacing: 2) {
                                    StarRating(rating: restaurant.rating, size: 12)
                                    Text("(\(restaurant.reviewCount))")
                                        .font(.system(size: 11))
                                        .foregroundColor(SafeEatColors.textTertiary)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .overlay(Rectangle().frame(height: 0.5).foregroundColor(SafeEatColors.border), alignment: .bottom)

                    // Safety Check
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader(title: "DEIN SICHERHEITS-CHECK")
                        VStack(spacing: 0) {
                            SafetyRow(
                                icon: "🌾",
                                label: "Gluten / Zöliakie",
                                description: "Eigene GF Küche, separate Fritteuse",
                                safety: restaurant.glutenSafety
                            )
                            Divider().padding(.leading, 52)
                            SafetyRow(
                                icon: "🥛",
                                label: "Laktose",
                                description: "Pflanzliche Alternativen verfügbar",
                                safety: restaurant.lactoseSafety
                            )
                        }
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(SafeEatColors.border, lineWidth: 0.5))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .overlay(Rectangle().frame(height: 0.5).foregroundColor(SafeEatColors.border), alignment: .bottom)

                    // Menu highlights
                    if !restaurant.menuItems.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader(title: "MENÜ-HIGHLIGHTS")
                            VStack(spacing: 0) {
                                ForEach(Array(restaurant.menuItems.enumerated()), id: \.element.id) { i, item in
                                    HStack {
                                        Text(item.name)
                                            .font(.system(size: 13))
                                            .foregroundColor(SafeEatColors.textPrimary)
                                        Spacer()
                                        HStack(spacing: 4) {
                                            ForEach(item.tags, id: \.self) { tag in
                                                Text(tag)
                                                    .font(.system(size: 10, weight: .medium))
                                                    .foregroundColor(item.safety.color)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 3)
                                                    .background(item.safety.bgColor)
                                                    .cornerRadius(4)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 11)
                                    if i < restaurant.menuItems.count - 1 {
                                        Divider().padding(.leading, 14)
                                    }
                                }
                            }
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(SafeEatColors.border, lineWidth: 0.5))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .overlay(Rectangle().frame(height: 0.5).foregroundColor(SafeEatColors.border), alignment: .bottom)
                    }

                    // Reviews
                    if !restaurant.reviews.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "COMMUNITY-BEWERTUNGEN")
                            ForEach(restaurant.reviews) { review in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 10) {
                                        ZStack {
                                            Circle()
                                                .fill(review.avatarColor)
                                                .frame(width: 32, height: 32)
                                            Text(review.initials)
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(SafeEatColors.green)
                                        }
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("\(review.name) · \(review.condition)")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(SafeEatColors.textPrimary)
                                            StarRating(rating: Double(review.rating), size: 11)
                                        }
                                    }
                                    Text(review.text)
                                        .font(.system(size: 13))
                                        .foregroundColor(SafeEatColors.textSecondary)
                                        .lineSpacing(3)
                                }
                                .padding(14)
                                .background(SafeEatColors.surface)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(SafeEatColors.border, lineWidth: 0.5))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }

                    Spacer().frame(height: 20)
                }
            }

            // CTA Footer
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 16))
                            .foregroundColor(SafeEatColors.textSecondary)
                            .frame(width: 52, height: 52)
                            .background(SafeEatColors.surface2)
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(SafeEatColors.border, lineWidth: 1))
                    }
                    Button(action: {}) {
                        HStack(spacing: 6) {
                            Image(systemName: "map.fill")
                                .font(.system(size: 15))
                            Text("Route starten")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(SafeEatColors.green)
                        .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }
            .background(Color.white)
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
}

// ── Preview ─────────────────────────────────────────────────
#Preview("Detail") {
    RestaurantDetailView(
        restaurant: Restaurant.sampleData[0],
        onBack: {}
    )
}
