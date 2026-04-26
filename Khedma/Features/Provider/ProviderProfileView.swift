import SwiftUI

struct ProviderProfileView: View {
    @EnvironmentObject private var preferences: AppPreferences
    @EnvironmentObject private var favorites: FavoritesViewModel
    let provider: Provider
    @State private var appeared = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                header
                quickStats
                bio
                portfolio
                services
                availability
                reviews
                trustSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 110)
        }
        .background(KhedmaBackground())
        .navigationTitle(KhedmaCopy.providerName(provider, language: preferences.language))
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            bottomBookingBar
        }
        .onAppear {
            favorites.noteViewed(provider)
            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                appeared = true
            }
        }
    }

    private var header: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottomLeading) {
                Image(KhedmaCopy.providerImageAsset(provider))
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: 330)
                    .clipped()
                LinearGradient(
                    colors: [.black.opacity(0.06), .black.opacity(0.76)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        Spacer()
                        Button {
                            favorites.toggle(provider)
                            triggerSoftHaptic()
                        } label: {
                            Image(systemName: favorites.isFavorite(provider) ? "heart.fill" : "heart")
                                .foregroundStyle(.white)
                                .frame(width: 46, height: 46)
                                .background(.white.opacity(0.18))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        TrustPill(text: preferences.language.copy(fr: "Vérifiée Khedma", ar: "موثقة من خدمة"), symbol: "checkmark.seal.fill", tint: .white)
                        Text(KhedmaCopy.providerName(provider, language: preferences.language))
                            .font(KhedmaFont.hero(31))
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(preferences.language.copy(fr: "\(KhedmaCopy.neighborhood(provider.neighborhood, language: preferences.language)) · \(provider.completedJobs) services · répond en \(KhedmaCopy.responseTime(provider.responseTime, language: preferences.language))", ar: "\(KhedmaCopy.neighborhood(provider.neighborhood, language: preferences.language)) · \(provider.completedJobs) خدمة · ترد خلال \(KhedmaCopy.responseTime(provider.responseTime, language: preferences.language))"))
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white.opacity(0.78))
                    }

                    HStack(spacing: 10) {
                        WorkerHeroBadge(title: preferences.language.copy(fr: "note", ar: "تقييم"), value: String(format: "%.2f", provider.rating))
                        WorkerHeroBadge(title: preferences.language.copy(fr: "ponctualité", ar: "التزام"), value: "\(provider.punctualityScore)%")
                        WorkerHeroBadge(title: preferences.language.copy(fr: "dès", ar: "من"), value: "\(provider.startingPrice)")
                    }
                }
                .padding(22)
                .frame(width: proxy.size.width, height: 330, alignment: .bottomLeading)
            }
        }
        .frame(height: 330)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 32, style: .continuous).stroke(.white.opacity(0.36), lineWidth: 1))
        .shadow(color: KhedmaTheme.ink.opacity(0.16), radius: 26, x: 0, y: 16)
    }

    private var quickStats: some View {
        HStack(spacing: 10) {
            StatTile(title: String(format: "%.2f", provider.rating), subtitle: preferences.language.copy(fr: "note", ar: "تقييم"), symbol: "star.fill")
            StatTile(title: "\(provider.completedJobs)", subtitle: preferences.language.copy(fr: "services", ar: "خدمات"), symbol: "checkmark.circle.fill")
            StatTile(title: KhedmaCopy.responseTime(provider.responseTime, language: preferences.language), subtitle: preferences.language.copy(fr: "réponse", ar: "رد"), symbol: "bolt.fill")
            StatTile(title: "\(provider.punctualityScore)%", subtitle: preferences.language.copy(fr: "ponctualité", ar: "التزام"), symbol: "clock.fill")
        }
    }

    private var bio: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: preferences.language.copy(fr: "À propos", ar: "نبذة"))
            Text(KhedmaCopy.providerBio(provider, language: preferences.language))
                .font(.subheadline.weight(.medium))
                .foregroundStyle(KhedmaTheme.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .khedmaCard()
    }

    private var portfolio: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Portfolio", ar: "الأعمال"), action: preferences.language.copy(fr: "Revu", ar: "مراجع"))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(provider.portfolio) { item in
                        PortfolioTile(item: item)
                    }
                }
            }
        }
    }

    private var services: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Services", ar: "الخدمات"))
            VStack(spacing: 10) {
                ForEach(provider.services) { service in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(KhedmaCopy.serviceName(service.id, fallback: service.name, language: preferences.language))
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(KhedmaTheme.ink)
                            Text(KhedmaCopy.duration(service.duration, language: preferences.language))
                                .font(.caption)
                                .foregroundStyle(KhedmaTheme.muted)
                        }
                        Spacer()
                        Text(preferences.language.copy(fr: "Dès \(service.startingPrice) MAD", ar: "ابتداءً من \(service.startingPrice) درهم"))
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(KhedmaTheme.accentDeep)
                    }
                    .padding(14)
                    .background(KhedmaTheme.surfaceWarm)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .khedmaCard(padding: 10)
        }
    }

    private var availability: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Disponibilités", ar: "المواعيد"))
            HStack(spacing: 10) {
                ForEach(provider.availability) { slot in
                    VStack(spacing: 4) {
                        Text(KhedmaCopy.availabilityLabel(slot.label, language: preferences.language))
                            .font(.caption.weight(.semibold))
                        Text(slot.time)
                            .font(.headline.weight(.bold))
                    }
                    .foregroundStyle(KhedmaTheme.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(KhedmaTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(KhedmaTheme.line, lineWidth: 1)
                    )
                }
            }
        }
    }

    private var reviews: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Avis", ar: "الآراء"))
            VStack(spacing: 12) {
                ForEach(provider.reviews) { review in
                    VStack(alignment: .leading, spacing: 7) {
                        HStack {
                            Text(KhedmaCopy.reviewAuthor(review, language: preferences.language))
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                            Label(String(format: "%.1f", review.rating), systemImage: "star.fill")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(KhedmaTheme.accentDeep)
                        }
                        Text(KhedmaCopy.reviewText(review, language: preferences.language))
                            .font(.subheadline)
                            .foregroundStyle(KhedmaTheme.muted)
                        Text(KhedmaCopy.reviewDate(review.date, language: preferences.language))
                            .font(.caption)
                            .foregroundStyle(KhedmaTheme.muted.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(KhedmaTheme.surfaceWarm)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .khedmaCard(padding: 10)
        }
    }

    private var trustSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Contrôles de confiance", ar: "تحققات الثقة"))
            VStack(spacing: 12) {
                ForEach(provider.trustBadges) { badge in
                    HStack(spacing: 12) {
                        Image(systemName: badge.symbol)
                            .foregroundStyle(KhedmaTheme.success)
                            .frame(width: 36, height: 36)
                            .background(KhedmaTheme.success.opacity(0.10))
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: 3) {
                            Text(KhedmaCopy.trustTitle(badge, language: preferences.language))
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(KhedmaTheme.ink)
                            Text(KhedmaCopy.trustSubtitle(badge, language: preferences.language))
                                .font(.caption)
                                .foregroundStyle(KhedmaTheme.muted)
                        }
                        Spacer()
                    }
                }
            }
            .khedmaCard()
        }
    }

    private var bottomBookingBar: some View {
        VStack(spacing: 0) {
            Divider().overlay(KhedmaTheme.line)
            HStack(spacing: 10) {
                NavigationLink {
                    ProviderChatView(provider: provider)
                } label: {
                    Image(systemName: "message.fill")
                        .foregroundStyle(KhedmaTheme.accentDeep)
                        .frame(width: 52, height: 52)
                        .background(KhedmaTheme.surfaceWarm)
                        .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
                }
                .buttonStyle(.plain)

                NavigationLink {
                    BookingFlowView(provider: provider)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(preferences.language.copy(fr: "Réserver", ar: "احجزي"))
                                .font(.headline.weight(.semibold))
                            Text(preferences.language.copy(fr: "Dès \(provider.startingPrice) MAD · assistance incluse", ar: "ابتداءً من \(provider.startingPrice) درهم · متابعة مشمولة"))
                                .font(.caption)
                                .opacity(0.85)
                        }
                        Spacer()
                        Image(systemName: "calendar.badge.plus")
                    }
                    .foregroundStyle(.white)
                    .padding(16)
                    .background(KhedmaTheme.accentDeep)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
        }
    }
}

struct StatTile: View {
    let title: String
    let subtitle: String
    let symbol: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: symbol)
                .font(.caption.weight(.bold))
                .foregroundStyle(KhedmaTheme.accent)
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundStyle(KhedmaTheme.ink)
                .minimumScaleFactor(0.75)
            Text(subtitle)
                .font(.caption2.weight(.medium))
                .foregroundStyle(KhedmaTheme.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 13)
        .background(KhedmaTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(KhedmaTheme.line, lineWidth: 1)
        )
    }
}

#Preview("Provider Profile") {
    NavigationStack {
        ProviderProfileView(provider: MockData.providers[0])
    }
    .khedmaPreviewEnvironment()
}
