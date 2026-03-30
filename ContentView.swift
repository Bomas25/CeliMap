import SwiftUI

// ── App Navigation ──────────────────────────────────────────
enum AppScreen {
    case splash
    case onboarding1
    case onboarding2
    case main
    case detail(Restaurant)
}

struct ContentView: View {
    @State private var screen: AppScreen = .splash
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack {
            switch screen {

            case .splash:
                SplashView(onStart: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        screen = .onboarding1
                    }
                })
                .transition(.opacity)

            case .onboarding1:
                IntoleranceSelectionView(onNext: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        screen = .onboarding2
                    }
                })
                .transition(.move(edge: .trailing))

            case .onboarding2:
                SeveritySelectionView(onFinish: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        screen = .main
                        selectedTab = 0
                    }
                })
                .transition(.move(edge: .trailing))

            case .main:
                mainTabView
                    .transition(.opacity)

            case .detail(let restaurant):
                RestaurantDetailView(
                    restaurant: restaurant,
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            screen = .main
                        }
                    }
                )
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }

    @ViewBuilder
    var mainTabView: some View {
        switch selectedTab {
        case 0:
            HomeMapView(
                selectedTab: $selectedTab,
                onRestaurantTap: { r in
                    withAnimation { screen = .detail(r) }
                }
            )
        case 1:
            RestaurantListView(
                selectedTab: $selectedTab,
                onRestaurantTap: { r in
                    withAnimation { screen = .detail(r) }
                }
            )
        case 2:
            SavedPlaceholderView(selectedTab: $selectedTab)
        case 3:
            ProfilePlaceholderView(selectedTab: $selectedTab)
        default:
            HomeMapView(selectedTab: $selectedTab, onRestaurantTap: { _ in })
        }
    }
}

// ── Placeholder Screens ─────────────────────────────────────
struct SavedPlaceholderView: View {
    @Binding var selectedTab: Int
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                Spacer()
                Text("🔖")
                    .font(.system(size: 48))
                Text("Gespeicherte Orte")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(SafeEatColors.textPrimary)
                Text("Restaurants, die du speicherst,\ntauchen hier auf.")
                    .font(.system(size: 14))
                    .foregroundColor(SafeEatColors.textSecondary)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            BottomNavBar(selected: $selectedTab)
        }
    }
}

struct ProfilePlaceholderView: View {
    @Binding var selectedTab: Int
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                Spacer()
                ZStack {
                    Circle()
                        .fill(SafeEatColors.greenLight)
                        .frame(width: 80, height: 80)
                    Text("LA")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(SafeEatColors.green)
                }
                Text("Lisa A.")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(SafeEatColors.textPrimary)
                VStack(spacing: 8) {
                    ProfileRow(icon: "🌾", label: "Gluten / Zöliakie", value: "Medizinisch")
                    ProfileRow(icon: "🥛", label: "Laktose",           value: "Sensitivität")
                }
                .padding(.horizontal, 24)
                Spacer()
            }
            BottomNavBar(selected: $selectedTab)
        }
    }
}

struct ProfileRow: View {
    var icon: String
    var label: String
    var value: String
    var body: some View {
        HStack {
            Text(icon).font(.system(size: 18)).frame(width: 28)
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(SafeEatColors.textPrimary)
            Spacer()
            Text(value)
                .font(.system(size: 13))
                .foregroundColor(SafeEatColors.textSecondary)
        }
        .padding(14)
        .background(SafeEatColors.surface)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(SafeEatColors.border, lineWidth: 0.5))
    }
}

// ── Preview ─────────────────────────────────────────────────
#Preview {
    ContentView()
}

#Preview("Ab Karte") {
    ContentView_StartAtMain()
}

struct ContentView_StartAtMain: View {
    @State private var selectedTab = 0
    var body: some View {
        HomeMapView(
            selectedTab: $selectedTab,
            onRestaurantTap: { _ in }
        )
    }
}
