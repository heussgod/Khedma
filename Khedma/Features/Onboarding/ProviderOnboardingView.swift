import SwiftUI

struct ProviderOnboardingView: View {
    @EnvironmentObject private var preferences: AppPreferences
    @State private var hasStarted = false
    @State private var didFinish = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                if didFinish {
                    submitted
                } else if hasStarted {
                    WorkerVerificationFlow {
                        withAnimation(.snappy) {
                            didFinish = true
                        }
                    }
                } else {
                    intro
                    verificationSummary
                    PrimaryButton(title: preferences.language.copy(fr: "Commencer la candidature", ar: "بدء الطلب"), subtitle: preferences.language.copy(fr: "Démarrer la vérification", ar: "بدء التحقق"), symbol: "arrow.right") {
                        withAnimation(.snappy) {
                            hasStarted = true
                        }
                    }
                }
            }
            .padding(20)
            .padding(.bottom, 28)
        }
        .background(KhedmaBackground())
        .navigationTitle(preferences.language.copy(fr: "Devenir professionnelle", ar: "أصبحي مهنية"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var intro: some View {
        PremiumHeroCard(palette: .ocean) {
            VStack(alignment: .leading, spacing: 16) {
                TrustPill(text: preferences.language.copy(fr: "Candidature pro", ar: "طلب مهنية"), symbol: "briefcase.fill", tint: .white)
                Image(systemName: "checkmark.seal.text.page.fill")
                    .font(.system(size: 62, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text(preferences.language.copy(fr: "Rejoindre une sélection, pas un marché ouvert.", ar: "انضمي إلى اختيار موثوق، وليس سوقًا مفتوحًا."))
                    .font(KhedmaFont.hero(31))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                Text(preferences.language.copy(fr: "Khedma vérifie identité, qualité, portfolio, disponibilités et conduite professionnelle avant les demandes clientes.", ar: "تراجع خدمة الهوية، الجودة، الأعمال، المواعيد، والسلوك المهني قبل فتح طلبات العميلات."))
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.78))
            }
        }
    }

    private var verificationSummary: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Parcours de vérification", ar: "مسار التحقق"))
            VStack(spacing: 12) {
                ForEach(MockData.onboardingSteps) { step in
                    VerificationPoint(title: KhedmaCopy.onboardingStepTitle(step, language: preferences.language), detail: KhedmaCopy.onboardingStepDetail(step, language: preferences.language), symbol: step.symbol)
                }
            }
            .khedmaCard()
        }
    }

    private var submitted: some View {
        VStack(alignment: .leading, spacing: 18) {
            PremiumHeroCard(palette: .gold) {
                VStack(alignment: .leading, spacing: 14) {
                    TrustPill(text: KhedmaCopy.applicationStatus(.underReview, language: preferences.language), symbol: "clock.badge.checkmark.fill", tint: .white)
                    Text(preferences.language.copy(fr: "Candidature envoyée", ar: "تم إرسال الطلب"))
                        .font(KhedmaFont.hero(32))
                        .foregroundStyle(.white)
                    Text(preferences.language.copy(fr: "Une coordinatrice Khedma relira ce profil avant l’ouverture aux demandes clientes.", ar: "ستراجع منسقة خدمة هذا الملف قبل فتح طلبات العميلات."))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.78))
                }
            }
            WhatsAppOperatorBubble()
        }
    }
}

#Preview("Provider Onboarding") {
    NavigationStack {
        ProviderOnboardingView()
    }
    .khedmaPreviewEnvironment()
}
