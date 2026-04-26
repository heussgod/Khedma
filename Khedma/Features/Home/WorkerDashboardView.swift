import SwiftUI

struct WorkerDashboardView: View {
    @EnvironmentObject private var preferences: AppPreferences

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                hero
                metrics
                verificationProgress
                selectedServices
                upcomingJobs
                earnings
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 120)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(KhedmaBackground())
        .navigationTitle(preferences.language.copy(fr: "Espace pro", ar: "مساحة العمل"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        PremiumHeroCard(palette: .ocean) {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    TrustPill(text: KhedmaCopy.applicationStatus(preferences.workerApplicationStatus, language: preferences.language), symbol: "clock.badge.checkmark.fill", tint: .white)
                    Spacer()
                    Text(KhedmaCopy.city(preferences.city, language: preferences.language))
                        .font(.caption.weight(.black))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.16))
                        .clipShape(Capsule())
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(preferences.language.copy(fr: "Construire votre réputation Khedma.", ar: "ابني سمعتك مع خدمة."))
                        .font(KhedmaFont.hero(32))
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(preferences.language.copy(fr: "Votre profil est en revue. Après validation, les demandes suivies et clientes récurrentes apparaîtront ici.", ar: "ملفك قيد المراجعة. بعد التوثيق، ستظهر هنا الطلبات المدعومة والعميلات المتكررات."))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.78))
                }

                HStack(spacing: 10) {
                    WorkerHeroBadge(title: preferences.language.copy(fr: "profil", ar: "الملف"), value: "72%")
                    WorkerHeroBadge(title: preferences.language.copy(fr: "réponse", ar: "الرد"), value: "--")
                    WorkerHeroBadge(title: preferences.language.copy(fr: "demandes", ar: "طلبات"), value: "0")
                }
            }
        }
    }

    private var metrics: some View {
        HStack(spacing: 12) {
            PremiumMetricTile(value: "72%", label: preferences.language.copy(fr: "force du profil", ar: "قوة الملف"), symbol: "chart.bar.fill")
            PremiumMetricTile(value: "4/7", label: preferences.language.copy(fr: "étapes", ar: "خطوات"), symbol: "checklist.checked")
            PremiumMetricTile(value: preferences.language.copy(fr: "0 MAD", ar: "0 درهم"), label: preferences.language.copy(fr: "revenus", ar: "الأرباح"), symbol: "banknote.fill")
        }
    }

    private var verificationProgress: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Progression de vérification", ar: "تقدم التحقق"), action: preferences.language.copy(fr: "Revue manuelle", ar: "مراجعة يدوية"))
            VStack(spacing: 12) {
                ApplicationStatusRow(status: .underReview, title: KhedmaCopy.applicationStatus(.underReview, language: preferences.language), detail: preferences.language.copy(fr: "Documents et portfolio sont avec l’équipe.", ar: "الوثائق والأعمال لدى الفريق."), isActive: true)
                ApplicationStatusRow(status: .verified, title: KhedmaCopy.applicationStatus(.verified, language: preferences.language), detail: preferences.language.copy(fr: "Les demandes s’ouvrent après approbation.", ar: "تُفتح الطلبات بعد الموافقة."), isActive: false)
                ApplicationStatusRow(status: .needMoreInfo, title: KhedmaCopy.applicationStatus(.needMoreInfo, language: preferences.language), detail: preferences.language.copy(fr: "Les demandes apparaîtront ici si un élément manque.", ar: "ستظهر الطلبات هنا إذا كان شيء ناقصًا."), isActive: false)
            }
            .khedmaCard()
        }
    }

    private var selectedServices: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Catégories choisies", ar: "الفئات المختارة"))
            FlowTagRow(tags: selectedCategoryNames)
                .khedmaCard()
        }
    }

    private var upcomingJobs: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Demandes à venir", ar: "الطلبات القادمة"))
            EmptyComingSoonView(
                title: preferences.language.copy(fr: "Aucune demande avant validation", ar: "لا طلبات قبل التوثيق"),
                detail: preferences.language.copy(fr: "Khedma ouvrira les réservations suivies après approbation.", ar: "ستفتح خدمة الحجوزات المدعومة بعد الموافقة.")
            )
        }
    }

    private var earnings: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Revenus", ar: "الأرباح"))
            HStack(spacing: 14) {
                ZStack {
                    VisualGradientBackground(palette: .gold)
                    Image(systemName: "banknote.fill")
                        .font(.title.weight(.bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 76, height: 76)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                VStack(alignment: .leading, spacing: 6) {
                    Text(preferences.language.copy(fr: "0 MAD", ar: "0 درهم"))
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(KhedmaTheme.ink)
                    Text(preferences.language.copy(fr: "Les revenus et versements apparaîtront après les demandes terminées.", ar: "ستظهر الأرباح والتحويلات بعد الطلبات المكتملة."))
                        .font(.caption)
                        .foregroundStyle(KhedmaTheme.muted)
                }
                Spacer()
            }
            .khedmaCard()
        }
    }

    private var selectedCategoryNames: [String] {
        let selected = Set(preferences.selectedInterestIDs)
        let names = MockData.workerCategoryOptions
            .filter { selected.contains($0.id) }
            .map { KhedmaCopy.selectableTitle($0, language: preferences.language) }
        return names.isEmpty ? [KhedmaCopy.specialty(.nails, language: preferences.language), KhedmaCopy.specialty(.makeup, language: preferences.language)] : names
    }
}

struct WorkerHeroBadge: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.headline.weight(.black))
                .foregroundStyle(.white)
            Text(title)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white.opacity(0.72))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.white.opacity(0.14))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview("Worker Dashboard") {
    NavigationStack {
        WorkerDashboardView()
    }
    .environmentObject(AppPreferences.previewWorker)
    .environmentObject(ProviderListViewModel.previewLoaded())
    .environmentObject(BookingsViewModel.preview)
    .environmentObject(FavoritesViewModel.preview)
}
