import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var preferences: AppPreferences
    @EnvironmentObject private var providerList: ProviderListViewModel
    @EnvironmentObject private var favorites: FavoritesViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                header
                providerSection(title: preferences.language.copy(fr: "Professionnelles sauvegardées", ar: "مهنيات محفوظات"), providers: savedProviders, showEmpty: true)
                providerSection(title: preferences.language.copy(fr: "Vues récemment", ar: "شوهدت مؤخرًا"), providers: recentProviders, showEmpty: false)
            }
            .padding(20)
            .padding(.bottom, 120)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(KhedmaBackground())
        .navigationTitle(preferences.language.copy(fr: "Favoris", ar: "المفضلة"))
    }

    private var header: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                Text(preferences.language.copy(fr: "\(savedProviders.count) profils enregistrés", ar: "\(savedProviders.count) ملفات محفوظة"))
                    .font(KhedmaFont.hero(23))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(preferences.language.copy(fr: "Pour réserver plus vite les professionnelles déjà validées par vous.", ar: "لحجز أسرع مع المهنيات اللواتي وثقتِ بهن."))
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
            }
            Spacer()
            Image(systemName: "heart.fill")
                .font(.headline.weight(.semibold))
                .foregroundStyle(KhedmaTheme.accentDeep)
                .frame(width: 44, height: 44)
                .background(KhedmaTheme.surfaceWarm)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
        .padding(.horizontal, 2)
    }

    @ViewBuilder
    private func providerSection(title: String, providers: [Provider], showEmpty: Bool) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: title)
            if providers.isEmpty && showEmpty {
                EmptyComingSoonView(
                    title: preferences.language.copy(fr: "Aucune favorite pour l’instant", ar: "لا توجد مفضلة بعد"),
                    detail: preferences.language.copy(fr: "Touchez le cœur d’une professionnelle vérifiée pour la retrouver vite.", ar: "اضغطي على القلب لدى مهنية موثوقة للعودة إليها بسرعة.")
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(providers) { provider in
                        FavoriteProviderRow(provider: provider)
                    }
                }
            }
        }
    }

    private var savedProviders: [Provider] {
        providerList.providers.filter { favorites.savedProviderIDs.contains($0.id) }
    }

    private var recentProviders: [Provider] {
        favorites.recentlyViewedProviderIDs.compactMap { providerList.provider(id: $0) }
    }
}

struct FavoriteProviderRow: View {
    @EnvironmentObject private var preferences: AppPreferences
    @EnvironmentObject private var favorites: FavoritesViewModel
    let provider: Provider

    var body: some View {
        HStack(spacing: 14) {
            NavigationLink {
                ProviderProfileView(provider: provider)
            } label: {
                HStack(spacing: 12) {
                    ProviderAvatarView(provider: provider, size: 58)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(KhedmaCopy.providerName(provider, language: preferences.language))
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(KhedmaTheme.ink)
                        Text(preferences.language.copy(fr: "\(KhedmaCopy.neighborhood(provider.neighborhood, language: preferences.language)) · \(String(format: "%.2f", provider.rating)) · \(provider.completedJobs) services", ar: "\(KhedmaCopy.neighborhood(provider.neighborhood, language: preferences.language)) · \(String(format: "%.2f", provider.rating)) · \(provider.completedJobs) خدمة"))
                            .font(.caption)
                            .foregroundStyle(KhedmaTheme.muted)
                        HStack(spacing: 6) {
                            Text(preferences.language.copy(fr: "Service habituel: \(KhedmaCopy.serviceName(provider.services.first?.id ?? "", fallback: provider.services.first?.name ?? "", language: preferences.language))", ar: "الخدمة المعتادة: \(KhedmaCopy.serviceName(provider.services.first?.id ?? "", fallback: provider.services.first?.name ?? "", language: preferences.language))"))
                                .lineLimit(1)
                                .minimumScaleFactor(0.78)
                            Text(nextAvailabilityText)
                                .lineLimit(1)
                        }
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(KhedmaTheme.accentDeep)
                    }
                }
            }
            .buttonStyle(.plain)

            Spacer()

            NavigationLink {
                BookingFlowView(provider: provider)
            } label: {
                Text(preferences.language.copy(fr: "Réserver", ar: "حجز"))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(KhedmaTheme.accentDeep)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Button {
                favorites.toggle(provider)
                triggerSoftHaptic()
            } label: {
                Image(systemName: favorites.isFavorite(provider) ? "heart.fill" : "heart")
                    .foregroundStyle(favorites.isFavorite(provider) ? KhedmaTheme.accent : KhedmaTheme.muted)
                    .frame(width: 34, height: 34)
                    .background(KhedmaTheme.surfaceWarm)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .khedmaCard()
    }

    private var nextAvailabilityText: String {
        guard let slot = provider.availability.first else {
            return preferences.language.copy(fr: "sur demande", ar: "حسب الطلب")
        }
        return preferences.language.copy(
            fr: "· \(KhedmaCopy.availabilityLabel(slot.label, language: preferences.language)) \(slot.time)",
            ar: "· \(KhedmaCopy.availabilityLabel(slot.label, language: preferences.language)) \(slot.time)"
        )
    }
}

#Preview("Favorites") {
    NavigationStack {
        FavoritesView()
    }
    .khedmaPreviewEnvironment()
}
