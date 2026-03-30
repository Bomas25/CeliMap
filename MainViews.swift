import SwiftUI
import MapKit

// ── Screen 4: Home / Karte ──────────────────────────────────
struct HomeMapView: View {
    @Binding var selectedTab: Int
    var onRestaurantTap: (Restaurant) -> Void

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.2082, longitude: 16.3738),
        span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
    )
    @State private var selectedFilter = 0
    let filters = ["GF + Laktosefrei", "Dediziert GF", "≤ 1 km", "Jetzt offen"]
    let restaurants = Restaurant.sampleData

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 10) {
                HStack {
                    Text("SafeEat")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(SafeEatColors.textPrimary)
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(SafeEatColors.greenLight)
                            .frame(width: 36, height: 36)
                            .overlay(Circle().stroke(SafeEatColors.greenMid, lineWidth: 1.5))
                        Text("LA")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(SafeEatColors.green)
                    }
                }

                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(SafeEatColors.textTertiary)
                        .font(.system(size: 15))
                    Text("Restaurant suchen...")
                        .font(.system(size: 14))
                        .foregroundColor(SafeEatColors.textTertiary)
                    Spacer()
                }
                .padding(12)
                .background(SafeEatColors.surface2)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(SafeEatColors.border, lineWidth: 1))

                // Filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<filters.count, id: \.self) { i in
                            Button(action: { selectedFilter = i }) {
                                Text(filters[i])
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(i == 0 ? .white : SafeEatColors.textSecondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(i == 0 ? SafeEatColors.green : SafeEatColors.surface)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(SafeEatColors.border, lineWidth: i == 0 ? 0 : 1)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 10)
            .background(Color.white)

            // Map
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $region, annotationItems: restaurants) { r in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(
                        latitude: 48.2082 + Double.random(in: -0.004...0.004),
                        longitude: 16.3738 + Double.random(in: -0.004...0.004)
                    )) {
                        VStack(spacing: 2) {
                            Text(r.name)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(r.name == "Grüner Teller" ? .white : SafeEatColors.textPrimary)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 4)
                                .background(r.name == "Grüner Teller" ? SafeEatColors.green : Color.white)
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
                            Rectangle()
                                .fill(r.name == "Grüner Teller" ? SafeEatColors.green : SafeEatColors.border)
                                .frame(width: 2, height: 6)
                        }
                    }
                }
                .ignoresSafeArea(edges: .horizontal)

                // Bottom preview card
                Button(action: { onRestaurantTap(restaurants[0]) }) {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "#E8F0E8"))
                                .frame(width: 44, height: 44)
                            Text("🥗").font(.system(size: 22))
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Grüner Teller")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(SafeEatColors.textPrimary)
                            Text("Österreichisch · 0.3 km")
                                .font(.system(size: 12))
                                .foregroundColor(SafeEatColors.textSecondary)
                            HStack(spacing: 4) {
                                SafeBadge(label: "✓ Dediziert GF", safety: .safe)
                                SafeBadge(label: "✓ Laktosefrei",  safety: .safe)
                            }
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 3) {
                            StarRating(rating: 4.0, size: 11)
                            Text("82").font(.system(size: 11)).foregroundColor(SafeEatColors.textTertiary)
                        }
                    }
                    .padding(14)
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 3)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
            }

            BottomNavBar(selected: $selectedTab)
        }
        .background(Color.white)
    }
}

// ── Screen 5: Suchergebnisse Liste ─────────────────────────
struct RestaurantListView: View {
    @Binding var selectedTab: Int
    var onRestaurantTap: (Restaurant) -> Void

    @State private var selectedFilter = 0
    let filters = ["Alle", "Dediziert GF", "GF + LF", "Jetzt offen"]
    let restaurants = Restaurant.sampleData

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Button(action: { selectedTab = 0 }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(SafeEatColors.textSecondary)
                            .frame(width: 32, height: 32)
                            .background(SafeEatColors.surface2)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(SafeEatColors.border, lineWidth: 1))
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Wien 1010 · GF + LF")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(SafeEatColors.textPrimary)
                        Text("14 Restaurants gefunden")
                            .font(.system(size: 12))
                            .foregroundColor(SafeEatColors.textTertiary)
                    }
                    Spacer()
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<filters.count, id: \.self) { i in
                            Button(action: { selectedFilter = i }) {
                                Text(filters[i])
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(i == selectedFilter ? .white : SafeEatColors.textSecondary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(i == selectedFilter ? SafeEatColors.textPrimary : Color.clear)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(i == selectedFilter ? SafeEatColors.textPrimary : SafeEatColors.border, lineWidth: 1)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 10)
            .background(Color.white)
            .overlay(Rectangle().frame(height: 0.5).foregroundColor(SafeEatColors.border), alignment: .bottom)

            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(restaurants) { r in
                        Button(action: { onRestaurantTap(r) }) {
                            RestaurantCard(restaurant: r)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(16)
            }

            BottomNavBar(selected: $selectedTab)
        }
        .background(Color.white)
    }
}

// ── Previews ────────────────────────────────────────────────
#Preview("Karte") {
    HomeMapView(selectedTab: .constant(0), onRestaurantTap: { _ in })
}

#Preview("Liste") {
    RestaurantListView(selectedTab: .constant(1), onRestaurantTap: { _ in })
}
