import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var preferences: AppPreferences
    private let profile = MockData.profile

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                profileHeader
                accountOverview
                profileSection(title: preferences.language.copy(fr: "Adresses enregistrées", ar: "العناوين المحفوظة"), items: profile.savedAddresses.map { KhedmaCopy.bookingAddress($0, language: preferences.language) }, symbol: "mappin.and.ellipse")
                profileSection(title: preferences.language.copy(fr: "Paiements", ar: "طرق الدفع"), items: localizedPaymentMethods, symbol: "creditcard.fill")
                settings
                profileSection(title: preferences.language.copy(fr: "Historique assistance", ar: "سجل المساعدة"), items: localizedSupportHistory, symbol: "clock.arrow.circlepath")
                inviteCard
                becomeProvider
                resetOnboarding
            }
            .padding(20)
            .padding(.bottom, 120)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(KhedmaBackground())
        .navigationTitle(preferences.language.copy(fr: "Profil", ar: "الملف"))
    }

    private var profileHeader: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(alignment: .top, spacing: 16) {
                ZStack {
                    LinearGradient(colors: [KhedmaTheme.gold, KhedmaTheme.clay], startPoint: .topLeading, endPoint: .bottomTrailing)
                    Text("LB")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                VStack(alignment: .leading, spacing: 8) {
                    TrustPill(text: preferences.role == .worker ? preferences.language.copy(fr: "Compte pro", ar: "حساب مهني") : preferences.language.copy(fr: "Compte cliente", ar: "حساب عميلة"), symbol: "person.crop.circle.fill", tint: preferences.role == .worker ? KhedmaTheme.ocean : KhedmaTheme.accentDeep)
                    Text(KhedmaCopy.customerName(profile.name, language: preferences.language))
                        .font(KhedmaFont.hero(24))
                        .foregroundStyle(KhedmaTheme.ink)
                    Text(preferences.language.copy(fr: "Coordonnées confirmées · \(KhedmaCopy.neighborhood(preferences.neighborhood, language: preferences.language))", ar: "بيانات مؤكدة · \(KhedmaCopy.neighborhood(preferences.neighborhood, language: preferences.language))"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(KhedmaTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }

            HStack(spacing: 7) {
                ProfileTrustDot(text: preferences.language.copy(fr: "Adresse confirmée", ar: "عنوان مؤكد"))
                ProfileTrustDot(text: preferences.language.copy(fr: "Assistance incluse", ar: "مساعدة مشمولة"))
            }
        }
        .khedmaCard()
    }

    private var accountOverview: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Compte", ar: "الحساب"))
            VStack(spacing: 10) {
                SettingsRow(title: preferences.language.copy(fr: "Téléphone", ar: "الهاتف"), detail: profile.phone, symbol: "phone.fill")
                SettingsRow(title: preferences.language.copy(fr: "Ville de service", ar: "مدينة الخدمة"), detail: "\(KhedmaCopy.city(preferences.city, language: preferences.language)), \(KhedmaCopy.neighborhood(preferences.neighborhood, language: preferences.language))", symbol: "location.fill")
                SettingsRow(title: preferences.language.copy(fr: "Langue", ar: "اللغة"), detail: preferences.language.displayName, symbol: "globe")
            }
            .khedmaCard()
        }
    }

    private func profileSection(title: String, items: [String], symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: title)
            VStack(spacing: 10) {
                ForEach(items, id: \.self) { item in
                    HStack(spacing: 12) {
                        Image(systemName: symbol)
                            .foregroundStyle(KhedmaTheme.accentDeep)
                            .frame(width: 34, height: 34)
                            .background(KhedmaTheme.surfaceWarm)
                            .clipShape(Circle())
                        Text(item)
                            .font(.subheadline)
                            .foregroundStyle(KhedmaTheme.ink)
                        Spacer()
                    }
                }
            }
            .khedmaCard()
        }
    }

    private var settings: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Préférences", ar: "التفضيلات"))
            VStack(spacing: 10) {
                SettingsRow(title: preferences.language.copy(fr: "Notifications", ar: "الإشعارات"), detail: preferences.language.copy(fr: "Confirmations et rappels", ar: "تأكيدات وتذكيرات"), symbol: "bell.fill")
                SettingsRow(title: preferences.language.copy(fr: "Préférence de paiement", ar: "تفضيل الدفع"), detail: KhedmaCopy.paymentMethod(.cash, language: preferences.language), symbol: "banknote.fill")
                SettingsRow(title: preferences.language.copy(fr: "Mode d’usage", ar: "طريقة الاستخدام"), detail: preferences.role.map { KhedmaCopy.roleTitle($0, language: preferences.language) } ?? preferences.language.copy(fr: "Cliente", ar: "عميلة"), symbol: "switch.2")
            }
            .khedmaCard()
        }
    }

    private var inviteCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "gift.fill")
                .foregroundStyle(KhedmaTheme.accentDeep)
                .frame(width: 44, height: 44)
                .background(KhedmaTheme.surfaceWarm)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(preferences.language.copy(fr: "Inviter des proches", ar: "دعوة المقربين"))
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(preferences.language.copy(fr: "Un lancement privé et fondé sur la confiance fonctionne mieux par recommandation.", ar: "الإطلاق الخاص المبني على الثقة ينجح أكثر عبر التوصيات."))
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
            }
            Spacer()
        }
        .khedmaCard()
    }

    private var becomeProvider: some View {
        NavigationLink {
            if preferences.role == .worker {
                WorkerDashboardView()
            } else {
                ProviderOnboardingView()
            }
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    VisualGradientBackground(palette: .ocean)
                    Image(systemName: preferences.role == .worker ? "chart.bar.fill" : "sparkles")
                        .foregroundStyle(.white)
                }
                .frame(width: 52, height: 52)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                VStack(alignment: .leading, spacing: 4) {
                    Text(preferences.role == .worker ? preferences.language.copy(fr: "Ouvrir l’espace pro", ar: "فتح مساحة العمل") : preferences.language.copy(fr: "Postuler comme professionnelle", ar: "التقديم كمهنية"))
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(KhedmaTheme.ink)
                    Text(preferences.role == .worker ? preferences.language.copy(fr: "Voir le statut et la force du profil.", ar: "عرض الحالة وقوة الملف.") : preferences.language.copy(fr: "Candidature vérifiée avant accès aux demandes clientes.", ar: "طلب تتم مراجعته قبل استقبال طلبات العميلات."))
                        .font(.caption)
                        .foregroundStyle(KhedmaTheme.muted)
                }
                Spacer()
                Image(systemName: preferences.language.isRTL ? "chevron.left" : "chevron.right")
                    .foregroundStyle(KhedmaTheme.muted)
            }
            .khedmaCard()
        }
        .buttonStyle(.plain)
    }

    private var resetOnboarding: some View {
        Button {
            preferences.resetOnboarding()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "arrow.counterclockwise")
                    .foregroundStyle(KhedmaTheme.accentDeep)
                    .frame(width: 42, height: 42)
                    .background(KhedmaTheme.surfaceWarm)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text(preferences.language.copy(fr: "Modifier mes préférences", ar: "تعديل تفضيلاتي"))
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(KhedmaTheme.ink)
                    Text(preferences.language.copy(fr: "Langue, rôle, ville, quartier et services d’intérêt.", ar: "اللغة، الدور، المدينة، الحي والخدمات المهمة لك."))
                        .font(.caption)
                        .foregroundStyle(KhedmaTheme.muted)
                }
                Spacer()
            }
            .khedmaCard()
        }
        .buttonStyle(.plain)
    }

    private var localizedPaymentMethods: [String] {
        [
            KhedmaCopy.paymentMethod(.cash, language: preferences.language),
            preferences.language.copy(fr: "Visa se terminant par 0426", ar: "فيزا تنتهي بـ 0426")
        ]
    }

    private var localizedSupportHistory: [String] {
        [
            preferences.language.copy(fr: "Horaire manucure gel modifié", ar: "تم تغيير وقت مانيكير الجل"),
            preferences.language.copy(fr: "Question de remboursement traitée", ar: "تمت معالجة طلب الاسترداد")
        ]
    }
}

private struct ProfileTrustDot: View {
    let text: String

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(KhedmaTheme.success)
                .frame(width: 6, height: 6)
            Text(text)
                .font(.caption2.weight(.bold))
                .foregroundStyle(KhedmaTheme.ink)
                .lineLimit(1)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
        .background(KhedmaTheme.surfaceWarm.opacity(0.94))
        .clipShape(Capsule())
    }
}

struct SettingsRow: View {
    let title: String
    let detail: String
    let symbol: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .foregroundStyle(KhedmaTheme.accentDeep)
                .frame(width: 34, height: 34)
                .background(KhedmaTheme.surfaceWarm)
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

#Preview("Profile") {
    NavigationStack {
        ProfileView()
    }
    .khedmaPreviewEnvironment()
}
