import SwiftUI

struct SupportView: View {
    @EnvironmentObject private var preferences: AppPreferences

    private var supportTopics: [SupportTopic] {
        [
            SupportTopic(title: preferences.language.copy(fr: "Modifier une réservation", ar: "تغيير الحجز"), detail: preferences.language.copy(fr: "Heure ou adresse", ar: "الوقت أو العنوان"), symbol: "calendar.badge.clock", palette: .ocean),
            SupportTopic(title: preferences.language.copy(fr: "Prix ou supplément", ar: "السعر أو مبلغ إضافي"), detail: preferences.language.copy(fr: "Clarification avant paiement", ar: "توضيح قبل الدفع"), symbol: "tag.fill", palette: .gold),
            SupportTopic(title: preferences.language.copy(fr: "Retard de la pro", ar: "تأخر المهنية"), detail: preferences.language.copy(fr: "Suivi en temps réel", ar: "متابعة مباشرة"), symbol: "clock.badge.exclamationmark.fill", palette: .olive),
            SupportTopic(title: preferences.language.copy(fr: "Sécurité", ar: "السلامة"), detail: preferences.language.copy(fr: "Priorité immédiate", ar: "أولوية عاجلة"), symbol: "shield.lefthalf.filled", palette: .ink),
            SupportTopic(title: preferences.language.copy(fr: "Qualité du service", ar: "جودة الخدمة"), detail: preferences.language.copy(fr: "Solution ou geste", ar: "حل أو تعويض"), symbol: "sparkle.magnifyingglass", palette: .rose),
            SupportTopic(title: preferences.language.copy(fr: "Remboursement", ar: "استرداد"), detail: preferences.language.copy(fr: "Revue après service", ar: "مراجعة بعد الخدمة"), symbol: "arrow.uturn.backward.circle.fill", palette: .clay)
        ]
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                hero
                supportThreadPreview
                supportGrid
                whatsAppButton
                faq
            }
            .padding(20)
            .padding(.bottom, 120)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(KhedmaBackground())
        .navigationTitle(preferences.language.copy(fr: "Assistance", ar: "المساعدة"))
    }

    private var hero: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "headset")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 46, height: 46)
                .background(KhedmaTheme.ocean)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            VStack(alignment: .leading, spacing: 7) {
                Text(preferences.language.copy(fr: "Assistance Khedma", ar: "مساعدة خدمة"))
                    .font(KhedmaFont.hero(23))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(preferences.language.copy(fr: "Un fil humain pour les changements, retards, prix, sécurité et qualité.", ar: "متابعة بشرية للتغيير، التأخير، السعر، السلامة والجودة."))
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(KhedmaTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(.horizontal, 2)
    }

    private var supportThreadPreview: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Fil de suivi actif", ar: "متابعة نشطة"), action: preferences.language.copy(fr: "5 min", ar: "5 د"))
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "person.crop.circle.badge.checkmark")
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(KhedmaTheme.success)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 5) {
                    Text(preferences.language.copy(fr: "Coordinatrice Khedma", ar: "منسقة خدمة"))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(KhedmaTheme.ink)
                    Text(preferences.language.copy(fr: "Votre prochain rendez-vous est suivi. Vous pouvez signaler un retard, confirmer l’adresse ou demander une intervention.", ar: "موعدك القادم تحت المتابعة. يمكنكِ الإبلاغ عن تأخير، تأكيد العنوان أو طلب تدخل."))
                        .font(.caption)
                        .foregroundStyle(KhedmaTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            VStack(alignment: .leading, spacing: 8) {
                SupportMessagePreview(
                    author: preferences.language.copy(fr: "Coordinatrice", ar: "المنسقة"),
                    text: preferences.language.copy(fr: "Je peux confirmer l’adresse ou déplacer le créneau si besoin.", ar: "يمكنني تأكيد العنوان أو تغيير الموعد إذا لزم الأمر."),
                    tint: KhedmaTheme.ocean
                )
                SupportMessagePreview(
                    author: preferences.language.copy(fr: "Vous", ar: "أنتِ"),
                    text: preferences.language.copy(fr: "Je veux garder le même horaire.", ar: "أريد الاحتفاظ بنفس الوقت."),
                    tint: KhedmaTheme.accentDeep
                )
            }
            FlowTagRow(tags: [
                preferences.language.copy(fr: "Adresse", ar: "العنوان"),
                preferences.language.copy(fr: "Retard", ar: "تأخير"),
                preferences.language.copy(fr: "Escalade", ar: "تصعيد")
            ])
        }
        .khedmaCard()
    }

    private var supportGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Comment pouvons-nous aider ?", ar: "كيف يمكننا المساعدة؟"))
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(supportTopics) { topic in
                    NavigationLink {
                        SupportIssueThreadView(topic: topic)
                    } label: {
                        SupportTopicCard(topic: topic)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var whatsAppButton: some View {
        Button(action: triggerSoftHaptic) {
            HStack(spacing: 12) {
                Image(systemName: "message.fill")
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(KhedmaTheme.success)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 3) {
                    Text(preferences.language.copy(fr: "Chat avec l’équipe", ar: "محادثة مع الفريق"))
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(KhedmaTheme.ink)
                    Text(preferences.language.copy(fr: "WhatsApp si une sortie app est nécessaire", ar: "واتساب عند الحاجة للخروج من التطبيق"))
                        .font(.caption)
                        .foregroundStyle(KhedmaTheme.muted)
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .foregroundStyle(KhedmaTheme.success)
            }
            .khedmaCard()
        }
        .buttonStyle(.plain)
    }

    private var faq: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: preferences.language.copy(fr: "Questions fréquentes", ar: "أسئلة شائعة"))
            FAQRow(question: preferences.language.copy(fr: "Les professionnelles sont-elles vérifiées ?", ar: "هل المهنيات موثقات؟"), answer: preferences.language.copy(fr: "Oui. Chaque profil listé passe par l’identité, l’entretien et la revue du portfolio.", ar: "نعم. كل ملف ظاهر يمر عبر الهوية، المقابلة، ومراجعة الأعمال."))
            FAQRow(question: preferences.language.copy(fr: "Le paiement se fait-il dans l’app ?", ar: "هل الدفع داخل التطبيق؟"), answer: preferences.language.copy(fr: "Pour le lancement Casablanca, l’option principale reste espèces après service.", ar: "في إطلاق الدار البيضاء، الخيار الأساسي هو الدفع نقدًا بعد الخدمة."))
            FAQRow(question: preferences.language.copy(fr: "Puis-je réserver la même personne à nouveau ?", ar: "هل يمكنني حجز نفس المهنية مرة أخرى؟"), answer: preferences.language.copy(fr: "Oui. Khedma est pensée pour la confiance et les réservations répétées.", ar: "نعم. خدمة مصممة للثقة والحجز المتكرر."))
        }
        .khedmaCard()
    }
}

private struct SupportMessagePreview: View {
    let author: String
    let text: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(author)
                .font(.caption2.weight(.black))
                .foregroundStyle(tint)
            Text(text)
                .font(.caption.weight(.medium))
                .foregroundStyle(KhedmaTheme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tint.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

private struct SupportTopic: Identifiable {
    let title: String
    let detail: String
    let symbol: String
    let palette: PortfolioPalette

    var id: String { title }
}

private struct SupportTopicCard: View {
    @EnvironmentObject private var preferences: AppPreferences
    let topic: SupportTopic

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 17, style: .continuous)
                        .fill(LinearGradient(colors: paletteColors(for: topic.palette), startPoint: .topLeading, endPoint: .bottomTrailing))
                    Image(systemName: topic.symbol)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
                Spacer()
                Image(systemName: preferences.language.isRTL ? "chevron.left" : "chevron.right")
                    .font(.caption.weight(.black))
                    .foregroundStyle(KhedmaTheme.muted.opacity(0.72))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                    .lineLimit(2)
                Text(topic.detail)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(KhedmaTheme.muted)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 138, alignment: .topLeading)
        .khedmaCard(padding: 14)
    }
}

private struct SupportIssueThreadView: View {
    @EnvironmentObject private var preferences: AppPreferences
    let topic: SupportTopic

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 10) {
                    TrustPill(text: preferences.language.copy(fr: "Traitement humain", ar: "معالجة بشرية"), symbol: "person.2.fill", tint: KhedmaTheme.ocean)
                    Text(topic.title)
                        .font(KhedmaFont.hero(25))
                        .foregroundStyle(KhedmaTheme.ink)
                    Text(issueOutcome)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(KhedmaTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .khedmaCard()

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: preferences.language.copy(fr: "Ce que l’équipe demandera", ar: "ما سيطلبه الفريق"))
                    IssueChecklistRow(text: preferences.language.copy(fr: "Réservation concernée", ar: "الحجز المعني"))
                    IssueChecklistRow(text: preferences.language.copy(fr: "Adresse ou créneau si nécessaire", ar: "العنوان أو الموعد عند الحاجة"))
                    IssueChecklistRow(text: preferences.language.copy(fr: "Photo ou détail clair si c’est un sujet qualité", ar: "صورة أو وصف واضح إذا كان الموضوع جودة"))
                }
                .khedmaCard()

                WhatsAppOperatorBubble()
            }
            .padding(20)
        }
        .background(KhedmaBackground())
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var issueOutcome: String {
        preferences.language.copy(
            fr: "Une coordinatrice ouvre un fil, vérifie le contexte et confirme la prochaine action avant clôture.",
            ar: "تفتح المنسقة متابعة، تتحقق من السياق وتؤكد الخطوة التالية قبل الإغلاق."
        )
    }
}

private struct IssueChecklistRow: View {
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(KhedmaTheme.success)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(KhedmaTheme.ink)
            Spacer()
        }
    }
}

struct FAQRow: View {
    let question: String
    let answer: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(question)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(KhedmaTheme.ink)
            Text(answer)
                .font(.caption)
                .foregroundStyle(KhedmaTheme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 5)
    }
}

#Preview("Support") {
    NavigationStack {
        SupportView()
    }
    .khedmaPreviewEnvironment()
}
