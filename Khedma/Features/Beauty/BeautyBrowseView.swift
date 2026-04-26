import SwiftUI

struct BeautyBrowseView: View {
    @EnvironmentObject private var preferences: AppPreferences
    @EnvironmentObject private var providerList: ProviderListViewModel
    @EnvironmentObject private var favorites: FavoritesViewModel
    @State private var selectedFilters: Set<BeautyFilter>
    @State private var selectedSort: BeautySortOption = .recommended

    init(initialSpecialty: BeautySpecialty? = nil) {
        let filter = Self.filter(for: initialSpecialty)
        _selectedFilters = State(initialValue: filter.map { Set([$0]) } ?? [])
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                marketplaceHeader
                filterChips
                sortControl
                providerResults
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 120)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(KhedmaBackground())
        .navigationTitle(preferences.language.copy(fr: "Beauté à domicile", ar: "الجمال في المنزل"))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await providerList.loadIfNeeded()
        }
    }

    private var marketplaceHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image("ServiceNails")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 58, height: 58)
                    .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 17, style: .continuous).stroke(.white.opacity(0.72), lineWidth: 1))
                VStack(alignment: .leading, spacing: 6) {
                    TrustPill(text: preferences.language.copy(fr: "Casablanca uniquement", ar: "الدار البيضاء فقط"), symbol: "location.fill", tint: KhedmaTheme.olive)
                    Text(preferences.language.copy(fr: "Beauté à domicile vérifiée", ar: "جمال منزلي موثق"))
                        .font(KhedmaFont.hero(21))
                        .foregroundStyle(KhedmaTheme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(preferences.language.copy(fr: "Une sélection courte, suivie par l’équipe, avec créneaux et quartiers lisibles.", ar: "اختيار محدود بمتابعة الفريق، مع مواعيد وأحياء واضحة."))
                        .font(.caption.weight(.medium))
                        .foregroundStyle(KhedmaTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }

            HStack(spacing: 8) {
                BrowseSignalPill(value: "\(providerList.providers.count)", label: preferences.language.copy(fr: "profils", ar: "ملفات"))
                BrowseSignalPill(value: "\(Set(providerList.providers.map { $0.neighborhood }).count)", label: preferences.language.copy(fr: "quartiers", ar: "أحياء"))
                BrowseSignalPill(value: preferences.language.copy(fr: "ID", ar: "هوية"), label: preferences.language.copy(fr: "vérifiés", ar: "موثقة"))
            }
        }
        .khedmaCard(padding: 15)
    }

    private var filterChips: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: preferences.language.copy(fr: "Affiner", ar: "تصفية"))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 9) {
                    ForEach(BeautyFilter.allCases) { filter in
                        Button {
                            withAnimation(.snappy) {
                                toggle(filter)
                            }
                            triggerSoftHaptic()
                        } label: {
                            ServiceChip(title: KhedmaCopy.beautyFilter(filter, language: preferences.language), isSelected: selectedFilters.contains(filter))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private var sortControl: some View {
        HStack {
            Text(preferences.language.copy(fr: "\(results.count) professionnelles sélectionnées", ar: "\(results.count) مهنيات مختارات"))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(KhedmaTheme.ink)
            Spacer()
            Menu {
                ForEach(BeautySortOption.allCases) { option in
                    Button(KhedmaCopy.beautySort(option, language: preferences.language)) {
                        selectedSort = option
                    }
                }
            } label: {
                Label(KhedmaCopy.beautySort(selectedSort, language: preferences.language), systemImage: "arrow.up.arrow.down")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(KhedmaTheme.accentDeep)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(KhedmaTheme.surface)
                    .clipShape(Capsule())
            }
        }
    }

    @ViewBuilder
    private var providerResults: some View {
        if providerList.isLoading {
            VStack(spacing: 14) {
                ForEach(0..<4, id: \.self) { _ in
                    SkeletonProviderCard()
                }
            }
        } else if results.isEmpty {
            EmptyComingSoonView(
                title: preferences.language.copy(fr: "Aucun résultat dans cette sélection", ar: "لا توجد نتيجة في هذه المجموعة"),
                detail: preferences.language.copy(fr: "Essayez un autre filtre. Khedma garde la sélection courte pendant la vérification de nouvelles professionnelles.", ar: "جربي فلترًا آخر. تحافظ خدمة على اختيار محدود أثناء توثيق مهنيات جديدات.")
            )
        } else {
            LazyVStack(spacing: 14) {
                ForEach(results) { provider in
                    NavigationLink {
                        ProviderProfileView(provider: provider)
                    } label: {
                        ProviderCard(
                            provider: provider,
                            isFavorite: favorites.isFavorite(provider),
                            onFavorite: {
                                favorites.toggle(provider)
                                triggerSoftHaptic()
                            }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var results: [Provider] {
        providerList.filteredProviders(filters: selectedFilters, sort: selectedSort)
    }

    private func toggle(_ filter: BeautyFilter) {
        if selectedFilters.contains(filter) {
            selectedFilters.remove(filter)
        } else {
            selectedFilters.insert(filter)
        }
    }

    private static func filter(for specialty: BeautySpecialty?) -> BeautyFilter? {
        switch specialty {
        case .nails: .nails
        case .hair: .hair
        case .makeup: .makeup
        case .browsLashes, .none: nil
        }
    }
}

private struct BrowseSignalPill: View {
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
        .padding(.vertical, 8)
        .background(KhedmaTheme.surfaceWarm.opacity(0.72))
        .clipShape(Capsule())
    }
}

#Preview("Beauty Browse") {
    NavigationStack {
        BeautyBrowseView()
    }
    .khedmaPreviewEnvironment()
}
