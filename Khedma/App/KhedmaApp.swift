import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

@main
struct KhedmaApp: App {
    @StateObject private var preferences = AppPreferences()
    @StateObject private var providers = ProviderListViewModel()
    @StateObject private var bookings = BookingsViewModel()
    @StateObject private var favorites = FavoritesViewModel()

    var body: some Scene {
        WindowGroup {
            RootSceneView()
                .environmentObject(preferences)
                .environmentObject(providers)
                .environmentObject(bookings)
                .environmentObject(favorites)
                .environment(\.layoutDirection, preferences.layoutDirection)
                .preferredColorScheme(.light)
        }
    }
}

struct RootSceneView: View {
    @EnvironmentObject private var preferences: AppPreferences

    var body: some View {
        Group {
            if preferences.hasCompletedOnboarding {
                MainTabView()
                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .opacity))
            } else {
                AppOnboardingFlowView()
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
        }
        .animation(.spring(response: 0.42, dampingFraction: 0.86), value: preferences.hasCompletedOnboarding)
    }
}

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case bookings
    case favorites
    case support
    case profile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "Accueil"
        case .bookings: "Réservations"
        case .favorites: "Favoris"
        case .support: "Assistance"
        case .profile: "Profil"
        }
    }

    func title(for role: UserRole?, language: KhedmaLanguage) -> String {
        KhedmaCopy.tab(self, role: role, language: language)
    }

    var icon: String {
        switch self {
        case .home: "house.fill"
        case .bookings: "calendar.badge.clock"
        case .favorites: "heart.fill"
        case .support: "message.fill"
        case .profile: "person.crop.circle.fill"
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject private var preferences: AppPreferences
    @State private var selectedTab: AppTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                selectedTab.rootView(role: preferences.role)
            }

            KhedmaTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
        .background(KhedmaBackground())
        .animation(.snappy(duration: 0.24), value: selectedTab)
    }
}

private struct KhedmaTabBar: View {
    @EnvironmentObject private var preferences: AppPreferences
    @Binding var selectedTab: AppTab

    private var visibleTabs: [AppTab] {
        AppTab.allCases
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(visibleTabs) { tab in
                Button {
                    triggerSoftHaptic()
                    selectedTab = tab
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 18, weight: selectedTab == tab ? .bold : .semibold))
                        Text(tab.title(for: preferences.role, language: preferences.language))
                            .font(.caption2.weight(selectedTab == tab ? .bold : .semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.72)
                    }
                    .foregroundStyle(selectedTab == tab ? KhedmaTheme.accentDeep : KhedmaTheme.muted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background {
                        if selectedTab == tab {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(KhedmaTheme.accentDeep.opacity(0.10))
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.title(for: preferences.role, language: preferences.language))
            }
        }
        .padding(7)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(KhedmaTheme.surface.opacity(0.78))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(.white.opacity(0.72), lineWidth: 1)
        )
        .shadow(color: KhedmaTheme.ink.opacity(0.14), radius: 24, x: 0, y: 14)
    }
}

@MainActor
private extension AppTab {
    @ViewBuilder
    func rootView(role: UserRole?) -> some View {
        switch self {
        case .home:
            if role == .worker {
                WorkerDashboardView()
            } else {
                HomeView()
            }
        case .bookings:
            BookingsView()
        case .favorites:
            FavoritesView()
        case .support:
            SupportView()
        case .profile:
            ProfileView()
        }
    }
}

// Centralized preview wiring keeps every screen independent of live services.
extension View {
    func khedmaPreviewEnvironment() -> some View {
        environmentObject(ProviderListViewModel.previewLoaded())
            .environmentObject(BookingsViewModel.preview)
            .environmentObject(FavoritesViewModel.preview)
            .environmentObject(AppPreferences.previewCustomer)
            .preferredColorScheme(.light)
    }
}

#Preview("iPhone 15 Pro") {
    RootSceneView()
        .khedmaPreviewEnvironment()
}

struct KhedmaIPhone15ProPreview: PreviewProvider {
    static var previews: some View {
        RootSceneView()
            .khedmaPreviewEnvironment()
            .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
            .previewDisplayName("iPhone 15 Pro")
    }
}
