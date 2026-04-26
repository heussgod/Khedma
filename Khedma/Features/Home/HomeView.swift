import SwiftUI
import MapKit

struct HomeView: View {
    @EnvironmentObject private var preferences: AppPreferences
    @EnvironmentObject private var providerList: ProviderListViewModel
    @EnvironmentObject private var bookings: BookingsViewModel
    @State private var searchText = ""
    @State private var selectedHomeZoneID: String? = MockData.coverageZones.first?.id
    @State private var homeMapPosition: MapCameraPosition = .region(ServiceMapGeometry.casablancaRegion)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                greeting
                searchBar
                coverageMapEntry
                departments
                beautyCategories
                featuredProviders
                rebookCard
                howItWorks
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 120)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(KhedmaBackground())
        .navigationTitle(preferences.language == .arabic ? "خدمة" : "Khedma")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var greeting: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image("ServiceBeautyHome")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 78, height: 92)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 21, style: .continuous))
                    .overlay(
                        LinearGradient(
                            colors: [.clear, KhedmaTheme.ink.opacity(0.20)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 21, style: .continuous))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 21, style: .continuous)
                            .stroke(.white.opacity(0.82), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 9) {
                    HStack(spacing: 8) {
                        TrustPill(text: preferences.language.copy(fr: "Casa", ar: "كازا"), symbol: "location.fill", tint: KhedmaTheme.accentDeep)
                        Text(preferences.language.copy(fr: "Beauté vérifiée", ar: "جمال موثق"))
                            .font(.caption.weight(.bold))
                            .foregroundStyle(KhedmaTheme.muted)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(KhedmaTheme.surfaceWarm.opacity(0.72))
                            .clipShape(Capsule())
                    }

                    Text(preferences.language.copy(fr: "Réservez une pro vérifiée.", ar: "احجزي مهنية موثقة."))
                        .font(KhedmaFont.hero(20))
                        .foregroundStyle(KhedmaTheme.ink)
                        .lineLimit(2)
                        .minimumScaleFactor(0.86)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(preferences.language.copy(fr: "Beauté à domicile, sélection courte, suivi inclus.", ar: "جمال منزلي، اختيار محدود، ومتابعة مشمولة."))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(KhedmaTheme.muted)
                        .lineLimit(2)
                        .minimumScaleFactor(0.84)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            HStack(spacing: 10) {
                HomeSignalTile(value: "3", label: preferences.language.copy(fr: "contrôles", ar: "تحقق"))
                HomeSignalTile(value: "4.9", label: preferences.language.copy(fr: "note", ar: "تقييم"))
                HomeSignalTile(value: "\(providerList.providers.count)", label: preferences.language.copy(fr: "pros vérifiées", ar: "مهنيات"))
            }
        }
        .khedmaCard(padding: 16)
    }

    private var searchBar: some View {
        ModernSearchBar(placeholder: preferences.language.copy(fr: "Rechercher un service beauté", ar: "ابحثي عن خدمة جمال"), text: $searchText)
    }

    private var coverageMapEntry: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(
                title: preferences.language.copy(fr: "Carte de service", ar: "خريطة الخدمة"),
                action: preferences.language.copy(fr: "Zones actives", ar: "مناطق نشطة")
            )

            VStack(alignment: .leading, spacing: 12) {
                InteractiveCoverageMap(
                    zones: MockData.coverageZones,
                    selectedZoneID: selectedHomeZoneID,
                    mapPosition: $homeMapPosition
                ) { zone in
                    withAnimation(.snappy) {
                        selectedHomeZoneID = zone.id
                        homeMapPosition = .region(ServiceMapGeometry.focusRegion(for: zone))
                    }
                }
                .frame(height: 204)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(.white.opacity(0.72), lineWidth: 1)
                )

                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 42, height: 42)
                        .background(KhedmaTheme.ocean)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 4) {
                        Text(selectedHomeZone.map { KhedmaCopy.neighborhood($0.neighborhood, language: preferences.language) } ?? preferences.language.copy(fr: "Casablanca", ar: "الدار البيضاء"))
                            .font(.headline.weight(.bold))
                            .foregroundStyle(KhedmaTheme.ink)
                        Text(homeMapDetail)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(KhedmaTheme.muted)
                            .lineLimit(1)
                            .minimumScaleFactor(0.82)
                    }
                    Spacer()
                    NavigationLink {
                        ServiceMapView()
                    } label: {
                        Image(systemName: preferences.language.isRTL ? "arrow.left" : "arrow.right")
                            .font(.caption.weight(.black))
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(KhedmaTheme.accentDeep)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(10)
                .background(KhedmaTheme.surfaceWarm.opacity(0.74))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .khedmaCard(padding: 12)
        }
    }

    private var departments: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Départements", ar: "الأقسام"), action: preferences.language.copy(fr: "Déploiement contrôlé", ar: "توسع منظم"))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(MockData.departments) { department in
                        NavigationLink {
                            switch department.status {
                            case .active:
                                BeautyBrowseView()
                            case .comingSoon:
                                ComingSoonDepartmentView(department: department)
                            }
                        } label: {
                            DepartmentCard(department: department)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private var beautyCategories: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Beauté à domicile", ar: "الجمال في المنزل"), action: preferences.language.copy(fr: "Disponible", ar: "متاح"))
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(MockData.beautyCategories) { category in
                    NavigationLink {
                        BeautyBrowseView(initialSpecialty: category.specialty)
                    } label: {
                        ServicePhotoCard(category: category)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var featuredProviders: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Professionnelles en avant", ar: "مهنيات مختارات"), action: preferences.language.copy(fr: "Vérifiées", ar: "موثقات"))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(providerList.providers.prefix(4)) { provider in
                        NavigationLink {
                            ProviderProfileView(provider: provider)
                        } label: {
                            FeaturedProviderTile(provider: provider)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    @ViewBuilder
    private var rebookCard: some View {
        if let booking = bookings.bookings(for: .past).first,
           let provider = providerList.provider(id: booking.providerID) {
            NavigationLink {
                BookingFlowView(provider: provider)
            } label: {
                HStack(spacing: 15) {
                    ProviderAvatarView(provider: provider, size: 68)
                    VStack(alignment: .leading, spacing: 6) {
                        TrustPill(text: preferences.language.copy(fr: "Réservation répétée", ar: "حجز متكرر"), symbol: "arrow.clockwise", tint: KhedmaTheme.accentDeep)
                        Text(KhedmaCopy.providerName(provider, language: preferences.language))
                            .font(.headline.weight(.bold))
                            .foregroundStyle(KhedmaTheme.ink)
                        Text(preferences.language.copy(fr: "Réserver à nouveau \(KhedmaCopy.bookingService(booking, language: preferences.language)) · \(booking.price) MAD", ar: "حجز \(KhedmaCopy.bookingService(booking, language: preferences.language)) مرة أخرى · \(booking.price) درهم"))
                            .font(.caption.weight(.medium))
                            .foregroundStyle(KhedmaTheme.muted)
                    }
                    Spacer()
                    Image(systemName: "arrow.clockwise")
                        .font(.headline.weight(.black))
                        .foregroundStyle(.white)
                        .frame(width: 42, height: 42)
                        .background(KhedmaTheme.accentDeep)
                        .clipShape(Circle())
                }
                .khedmaCard()
            }
            .buttonStyle(.plain)
        }
    }

    private var howItWorks: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Comment ça marche", ar: "كيف يعمل"))
            VStack(spacing: 14) {
                StepRow(number: "1", title: preferences.language.copy(fr: "Choisir un service", ar: "اختيار خدمة"), detail: preferences.language.copy(fr: "Un menu beauté court et vérifié.", ar: "قائمة جمال قصيرة وموثوقة."))
                StepRow(number: "2", title: preferences.language.copy(fr: "Réserver une pro vérifiée", ar: "حجز مهنية موثوقة"), detail: preferences.language.copy(fr: "Contrôles, avis et créneaux visibles.", ar: "تحقق، آراء، ومواعيد واضحة."))
                StepRow(number: "3", title: preferences.language.copy(fr: "Payer après le service", ar: "الدفع بعد الخدمة"), detail: preferences.language.copy(fr: "Espèces après service pour le lancement.", ar: "الدفع نقدًا بعد الخدمة في الإطلاق الأول."))
            }
            .khedmaCard(padding: 18)
        }
    }

    private func palette(for specialty: BeautySpecialty) -> PortfolioPalette {
        switch specialty {
        case .nails: .rose
        case .hair: .clay
        case .makeup: .ink
        case .browsLashes: .olive
        }
    }

    private var selectedHomeZone: CoverageZone? {
        MockData.coverageZones.first { $0.id == selectedHomeZoneID } ?? MockData.coverageZones.first
    }

    private var homeMapDetail: String {
        guard let selectedHomeZone else {
            return preferences.language.copy(fr: "Couverture vérifiée par quartier.", ar: "تغطية موثوقة حسب الحي.")
        }
        return preferences.language.copy(
            fr: "\(selectedHomeZone.providerCount) pros vérifiées · créneaux \(KhedmaCopy.coverageETA(selectedHomeZone.etaRange, language: preferences.language))",
            ar: "\(selectedHomeZone.providerCount) مهنيات موثقات · مواعيد خلال \(KhedmaCopy.coverageETA(selectedHomeZone.etaRange, language: preferences.language))"
        )
    }

}

private struct HomeSignalTile: View {
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 5) {
            Text(value)
                .font(.caption.weight(.black))
                .foregroundStyle(KhedmaTheme.ink)
            Text(label)
                .font(.caption2.weight(.bold))
                .foregroundStyle(KhedmaTheme.muted)
                .lineLimit(1)
                .minimumScaleFactor(0.76)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 9)
        .padding(.vertical, 7)
        .background(KhedmaTheme.surfaceWarm.opacity(0.70))
        .clipShape(Capsule())
    }
}

struct FeaturedProviderTile: View {
    @EnvironmentObject private var preferences: AppPreferences
    let provider: Provider

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(KhedmaCopy.providerImageAsset(provider))
                .resizable()
                .scaledToFill()
            LinearGradient(
                colors: [.black.opacity(0.04), .black.opacity(0.72)],
                startPoint: .top,
                endPoint: .bottom
            )
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Spacer()
                    TrustPill(text: String(format: "%.2f", provider.rating), symbol: "star.fill", tint: .white)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text(KhedmaCopy.providerName(provider, language: preferences.language))
                        .font(.headline.weight(.black))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    Text(preferences.language.copy(fr: "\(KhedmaCopy.neighborhood(provider.neighborhood, language: preferences.language)) · dès \(provider.startingPrice) MAD", ar: "\(KhedmaCopy.neighborhood(provider.neighborhood, language: preferences.language)) · ابتداءً من \(provider.startingPrice) درهم"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.75))
                }
            }
            .padding(16)
        }
        .frame(width: 190, height: 238, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 30, style: .continuous).stroke(.white.opacity(0.34), lineWidth: 1))
        .shadow(color: KhedmaTheme.ink.opacity(0.16), radius: 22, x: 0, y: 14)
    }
}

struct StepRow: View {
    let number: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(LinearGradient(colors: [KhedmaTheme.accentDeep, KhedmaTheme.accent], startPoint: .topLeading, endPoint: .bottomTrailing))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
            }
            Spacer()
        }
    }
}

struct ComingSoonDepartmentView: View {
    @EnvironmentObject private var preferences: AppPreferences
    let department: Department

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                EmptyComingSoonView(
                    title: preferences.language.copy(fr: "\(KhedmaCopy.departmentTitle(department, language: preferences.language)) arrive bientôt", ar: "\(KhedmaCopy.departmentTitle(department, language: preferences.language)) قريبًا"),
                    detail: preferences.language.copy(fr: "Khedma lance les départements un par un pour garder chaque service vérifié, suivi et fiable.", ar: "تطلق خدمة الأقسام واحدًا تلو الآخر حتى تبقى كل خدمة موثوقة ومدعومة.")
                )
                Text(preferences.language.copy(fr: "Beauté à domicile est le premier département actif à Casablanca.", ar: "الجمال في المنزل هو أول قسم متاح في الدار البيضاء."))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(KhedmaTheme.accentDeep)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .khedmaCard()
            }
            .padding(20)
        }
        .background(KhedmaBackground())
        .navigationTitle(KhedmaCopy.departmentTitle(department, language: preferences.language))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Home") {
    NavigationStack {
        HomeView()
    }
    .khedmaPreviewEnvironment()
}
