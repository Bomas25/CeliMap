import SwiftUI

// ── Screen 1: Splash ────────────────────────────────────────
struct SplashView: View {
    var onStart: () -> Void

    var body: some View {
        ZStack {
            SafeEatColors.green.ignoresSafeArea()

            // Background circles
            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 300)
                .offset(x: 130, y: -180)
            Circle()
                .fill(Color.white.opacity(0.04))
                .frame(width: 220)
                .offset(x: -120, y: 200)

            VStack(spacing: 0) {
                Spacer()

                // Logo icon
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 80, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
                        )
                    Text("🌿")
                        .font(.system(size: 36))
                }
                .padding(.bottom, 28)

                // Headline
                Text("Essen ohne\nSorgen.")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)

                // Subtext
                Text("Finde Restaurants, die wirklich\nzu deinen Bedürfnissen passen.")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.bottom, 52)

                // CTA Button
                Button(action: onStart) {
                    Text("Loslegen →")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(SafeEatColors.green)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(14)
                }
                .padding(.bottom, 12)

                // Ghost button
                Button(action: {}) {
                    Text("Ich habe schon ein Konto")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                        )
                }

                Spacer().frame(height: 40)
            }
            .padding(.horizontal, 24)
        }
    }
}

// ── Screen 2: Unverträglichkeit wählen ─────────────────────
struct IntoleranceSelectionView: View {
    @State private var intolerances: [Intolerance] = [
        Intolerance(name: "Gluten / Zöliakie", description: "Weizen, Roggen, Gerste, Hafer", emoji: "🌾", isSelected: true),
        Intolerance(name: "Laktose",           description: "Milch, Käse, Butter, Sahne",    emoji: "🥛", isSelected: true),
        Intolerance(name: "Nüsse",             description: "Erdnüsse, Baumnüsse, Mandeln",   emoji: "🥜", isSelected: false),
        Intolerance(name: "Eier",              description: "Alle Eigelbprodukte",            emoji: "🥚", isSelected: false),
        Intolerance(name: "Soja",              description: "Sojaprodukte, Tofu, Miso",       emoji: "🫘", isSelected: false)
    ]
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Progress
            ProgressView(value: 0.33)
                .tint(SafeEatColors.green)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Was verträgst\ndu nicht?")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(SafeEatColors.textPrimary)
                        Text("Wähle alle zutreffenden Optionen.")
                            .font(.system(size: 14))
                            .foregroundColor(SafeEatColors.textSecondary)
                    }

                    VStack(spacing: 10) {
                        ForEach($intolerances) { $item in
                            ChoiceItem(
                                label: item.name,
                                description: item.description,
                                emoji: item.emoji,
                                isSelected: $item.isSelected
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
            }

            // Step dots + CTA
            VStack(spacing: 16) {
                HStack(spacing: 6) {
                    Circle().fill(SafeEatColors.green).frame(width: 7, height: 7)
                    Circle().fill(SafeEatColors.border).frame(width: 7, height: 7)
                    Circle().fill(SafeEatColors.border).frame(width: 7, height: 7)
                }
                GreenButton(label: "Weiter →", action: onNext)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(SafeEatColors.surface)
        }
        .background(Color.white)
    }
}

// ── Screen 3: Schweregrad ───────────────────────────────────
struct SeveritySelectionView: View {
    @State private var selectedIndex = 0
    var onFinish: () -> Void

    let options: [(title: String, desc: String)] = [
        ("Zöliakie (medizinisch)",  "Kreuzverunreinigung ist kritisch"),
        ("Glutensensitivität",       "Kleine Mengen meist tolerierbar"),
        ("Lifestyle / bewusst",      "Kein medizinischer Grund")
    ]

    var body: some View {
        VStack(spacing: 0) {
            ProgressView(value: 0.66)
                .tint(SafeEatColors.green)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Wie streng\nbei Gluten?")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(SafeEatColors.textPrimary)
                        Text("Das beeinflusst, welche Restaurants wir dir zeigen.")
                            .font(.system(size: 14))
                            .foregroundColor(SafeEatColors.textSecondary)
                    }

                    VStack(spacing: 10) {
                        ForEach(0..<options.count, id: \.self) { i in
                            Button(action: { selectedIndex = i }) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .stroke(i == selectedIndex ? SafeEatColors.green : SafeEatColors.border, lineWidth: 1.5)
                                            .frame(width: 22, height: 22)
                                        if i == selectedIndex {
                                            Circle()
                                                .fill(SafeEatColors.green)
                                                .frame(width: 22, height: 22)
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 8, height: 8)
                                        }
                                    }
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(options[i].title)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(SafeEatColors.textPrimary)
                                        Text(options[i].desc)
                                            .font(.system(size: 12))
                                            .foregroundColor(SafeEatColors.textSecondary)
                                    }
                                    Spacer()
                                }
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(i == selectedIndex ? SafeEatColors.greenLight : SafeEatColors.surface)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(i == selectedIndex ? SafeEatColors.green : SafeEatColors.border, lineWidth: 1.5)
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }

                    // Info box
                    HStack(alignment: .top, spacing: 10) {
                        Text("💡")
                            .font(.system(size: 14))
                        Text("Bei Zöliakie zeigen wir nur Restaurants mit separater GF-Küche oder streng gesicherten Prozessen.")
                            .font(.system(size: 12))
                            .foregroundColor(SafeEatColors.green)
                            .lineSpacing(3)
                    }
                    .padding(14)
                    .background(SafeEatColors.greenLight)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(SafeEatColors.green.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
            }

            VStack(spacing: 16) {
                HStack(spacing: 6) {
                    Circle().fill(SafeEatColors.border).frame(width: 7, height: 7)
                    Circle().fill(SafeEatColors.green).frame(width: 7, height: 7)
                    Circle().fill(SafeEatColors.border).frame(width: 7, height: 7)
                }
                GreenButton(label: "Fertig & Restaurants entdecken →", action: onFinish)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(SafeEatColors.surface)
        }
        .background(Color.white)
    }
}

// ── Previews ────────────────────────────────────────────────
#Preview("Splash") {
    SplashView(onStart: {})
}

#Preview("Unverträglichkeit") {
    IntoleranceSelectionView(onNext: {})
}

#Preview("Schweregrad") {
    SeveritySelectionView(onFinish: {})
}
