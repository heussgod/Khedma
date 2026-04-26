import SwiftUI

struct WorkerVerificationFlow: View {
    @EnvironmentObject private var preferences: AppPreferences
    let onComplete: () -> Void
    @State private var stepIndex = 0
    @State private var selectedServices: Set<String> = ["nails", "makeup"]
    @State private var selectedCity = "Casablanca"
    @State private var selectedNeighborhood = "Maarif"
    @State private var yearsOfExperience = 3
    @State private var hasCertification = false
    @State private var availability: Set<String> = ["weekday-morning", "saturday"]
    @State private var didSubmit = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if didSubmit {
                applicationStatus
            } else {
                header
                stepCard
                controls
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                TrustPill(text: preferences.language.copy(fr: "Vérification pro", ar: "تحقق المهنية"), symbol: "checkmark.shield.fill", tint: KhedmaTheme.accentDeep)
                Spacer()
                Text("\(stepIndex + 1)/\(MockData.onboardingSteps.count)")
                    .font(.caption.weight(.black))
                    .foregroundStyle(KhedmaTheme.gold)
            }
            HStack(spacing: 6) {
                ForEach(MockData.onboardingSteps.indices, id: \.self) { index in
                    Capsule()
                        .fill(index <= stepIndex ? KhedmaTheme.accentDeep : KhedmaTheme.line.opacity(0.85))
                        .frame(height: 6)
                }
            }
        }
        .khedmaCard()
    }

    private var stepCard: some View {
        let step = MockData.onboardingSteps[stepIndex]
        return VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 14) {
                ZStack {
                    VisualGradientBackground(palette: palette(for: step.id))
                    Image(systemName: step.symbol)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: 68, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                VStack(alignment: .leading, spacing: 5) {
                    Text(KhedmaCopy.onboardingStepTitle(step, language: preferences.language))
                        .font(.title3.weight(.black))
                        .foregroundStyle(KhedmaTheme.ink)
                    Text(KhedmaCopy.onboardingStepDetail(step, language: preferences.language))
                        .font(.subheadline)
                        .foregroundStyle(KhedmaTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Divider().overlay(KhedmaTheme.line)

            stepDetail(for: step)
        }
        .khedmaCard(padding: 18)
    }

    @ViewBuilder
    private func stepDetail(for step: OnboardingStep) -> some View {
        switch step.id {
        case "id":
            MockUploadPanel(title: preferences.language.copy(fr: "Pièce d’identité", ar: "بطاقة الهوية"), detail: preferences.language.copy(fr: "Recto-verso, CIN marocaine ou passeport.", ar: "الوجه والظهر، بطاقة وطنية مغربية أو جواز."), symbol: "person.text.rectangle.fill", palette: .ocean)
        case "selfie":
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    VisualGradientBackground(palette: .gold)
                    Circle()
                        .stroke(.white.opacity(0.55), lineWidth: 3)
                        .frame(width: 110, height: 110)
                    Image(systemName: "face.smiling.fill")
                        .font(.system(size: 58, weight: .regular))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .frame(height: 170)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                Text(preferences.language.copy(fr: "Contrôle caméra : bonne lumière, visage visible, même personne que la pièce.", ar: "تحقق الكاميرا: إضاءة جيدة، وجه واضح، نفس الشخص في الوثيقة."))
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
            }
        case "services":
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(MockData.workerCategoryOptions.prefix(6)) { option in
                    Button {
                        if selectedServices.contains(option.id) {
                            selectedServices.remove(option.id)
                        } else {
                            selectedServices.insert(option.id)
                        }
                    } label: {
                        ServiceChip(title: KhedmaCopy.selectableTitle(option, language: preferences.language), isSelected: selectedServices.contains(option.id))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
        case "city":
            VStack(alignment: .leading, spacing: 14) {
                Text(preferences.language.copy(fr: "Ville", ar: "المدينة"))
                    .font(.caption.weight(.black))
                    .foregroundStyle(KhedmaTheme.muted)
                    .textCase(.uppercase)
                HStack(spacing: 10) {
                    ForEach(MockData.cities, id: \.self) { city in
                        Button {
                            selectedCity = city
                            selectedNeighborhood = MockData.neighborhoodsByCity[city]?.first ?? ""
                            triggerSoftHaptic()
                        } label: {
                            ServiceChip(title: KhedmaCopy.city(city, language: preferences.language), isSelected: selectedCity == city)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text(preferences.language.copy(fr: "Quartier", ar: "الحي"))
                    .font(.caption.weight(.black))
                    .foregroundStyle(KhedmaTheme.muted)
                    .textCase(.uppercase)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(MockData.neighborhoodsByCity[selectedCity] ?? [], id: \.self) { area in
                        Button {
                            selectedNeighborhood = area
                            triggerSoftHaptic()
                        } label: {
                            HStack(spacing: 8) {
                                Text(KhedmaCopy.neighborhood(area, language: preferences.language))
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(selectedNeighborhood == area ? .white : KhedmaTheme.ink)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.78)
                                Spacer(minLength: 4)
                                Image(systemName: selectedNeighborhood == area ? "checkmark.circle.fill" : "circle")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(selectedNeighborhood == area ? .white : KhedmaTheme.line)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 11)
                            .background(selectedNeighborhood == area ? KhedmaTheme.accentDeep : KhedmaTheme.surface.opacity(0.86))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(selectedNeighborhood == area ? KhedmaTheme.gold.opacity(0.55) : .white.opacity(0.72), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                SummaryRow(title: preferences.language.copy(fr: "Zone sélectionnée", ar: "المنطقة المختارة"), detail: "\(KhedmaCopy.city(selectedCity, language: preferences.language)), \(KhedmaCopy.neighborhood(selectedNeighborhood, language: preferences.language))", isStrong: true)
            }
        case "experience":
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("\(yearsOfExperience)")
                        .font(KhedmaFont.hero(48))
                        .foregroundStyle(KhedmaTheme.accentDeep)
                    Text(preferences.language.copy(fr: "années d’expérience", ar: "سنوات خبرة"))
                        .font(.headline.weight(.bold))
                        .foregroundStyle(KhedmaTheme.ink)
                    Spacer()
                }
                Stepper(preferences.language.copy(fr: "Ajuster les années", ar: "تعديل السنوات"), value: $yearsOfExperience, in: 0...25)
                    .font(.subheadline.weight(.semibold))
            }
        case "portfolio":
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    ForEach([preferences.language.copy(fr: "Glam doux", ar: "مكياج ناعم"), preferences.language.copy(fr: "Gel", ar: "جل"), preferences.language.copy(fr: "Coiffure", ar: "تصفيف")], id: \.self) { title in
                        PortfolioTile(item: PortfolioWork(id: title, title: title, subtitle: preferences.language.copy(fr: "Exemple ajouté", ar: "مثال مضاف"), symbol: "photo.fill", palette: .rose))
                            .frame(width: 106, height: 124)
                            .clipped()
                    }
                }
                MockUploadPanel(title: preferences.language.copy(fr: "Ajouter des photos", ar: "إضافة صور"), detail: preferences.language.copy(fr: "Les avant/après aident la revue qualité.", ar: "صور قبل/بعد تساعد في مراجعة الجودة."), symbol: "plus", palette: .sand)
            }
        case "certs":
            Toggle(isOn: $hasCertification) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(preferences.language.copy(fr: "J’ai des certifications ou licences", ar: "لدي شهادات أو رخص"))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(KhedmaTheme.ink)
                    Text(preferences.language.copy(fr: "Demandé pour certaines catégories qualifiées.", ar: "مطلوب لبعض الفئات الحرفية."))
                        .font(.caption)
                        .foregroundStyle(KhedmaTheme.muted)
                }
            }
            .tint(KhedmaTheme.accentDeep)
        case "availability":
            let options = ["weekday-morning", "weekday-evening", "saturday", "sunday", "same-day"]
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(options, id: \.self) { option in
                    Button {
                        if availability.contains(option) {
                            availability.remove(option)
                        } else {
                            availability.insert(option)
                        }
                    } label: {
                        ServiceChip(title: availabilityLabel(option), isSelected: availability.contains(option))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
        case "submit":
            VStack(alignment: .leading, spacing: 12) {
                SummaryRow(title: preferences.language.copy(fr: "Services", ar: "الخدمات"), detail: localizedSelectedServices, isStrong: true)
                SummaryRow(title: preferences.language.copy(fr: "Zone", ar: "المنطقة"), detail: "\(KhedmaCopy.city(selectedCity, language: preferences.language)), \(KhedmaCopy.neighborhood(selectedNeighborhood, language: preferences.language))")
                SummaryRow(title: preferences.language.copy(fr: "Expérience", ar: "الخبرة"), detail: preferences.language.copy(fr: "\(yearsOfExperience) ans", ar: "\(yearsOfExperience) سنوات"))
                SummaryRow(title: preferences.language.copy(fr: "Disponibilité", ar: "التوفر"), detail: availability.sorted().map(availabilityLabel).joined(separator: ", "))
                SummaryRow(title: preferences.language.copy(fr: "Documents", ar: "الوثائق"), detail: hasCertification ? preferences.language.copy(fr: "Certification ajoutée", ar: "تمت إضافة شهادة") : preferences.language.copy(fr: "Aucune certification ajoutée", ar: "لم تتم إضافة شهادة"))
            }
        default:
            EmptyView()
        }
    }

    private var controls: some View {
        HStack(spacing: 12) {
            if stepIndex > 0 {
                Button {
                    withAnimation(.snappy) {
                        stepIndex -= 1
                    }
                } label: {
                    Text(preferences.language.copy(fr: "Retour", ar: "رجوع"))
                        .font(.headline.weight(.bold))
                        .foregroundStyle(KhedmaTheme.ink)
                        .frame(width: 88)
                        .padding(.vertical, 16)
                        .background(KhedmaTheme.surface.opacity(0.88))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)
            }

            Button {
                if stepIndex == MockData.onboardingSteps.count - 1 {
                    withAnimation(.snappy) {
                        didSubmit = true
                    }
                } else {
                    withAnimation(.snappy) {
                        stepIndex += 1
                    }
                }
                triggerSoftHaptic()
            } label: {
                Text(stepIndex == MockData.onboardingSteps.count - 1 ? preferences.language.copy(fr: "Envoyer pour revue", ar: "إرسال للمراجعة") : preferences.language.copy(fr: "Continuer", ar: "متابعة"))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(LinearGradient(colors: [KhedmaTheme.accentDeep, KhedmaTheme.merlot], startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }

    private var applicationStatus: some View {
        VStack(alignment: .leading, spacing: 18) {
            PremiumHeroCard(palette: .gold) {
                VStack(alignment: .leading, spacing: 14) {
                    TrustPill(text: preferences.language.copy(fr: "Candidature envoyée", ar: "تم إرسال الطلب"), symbol: "paperplane.fill", tint: .white)
                    Text(preferences.language.copy(fr: "Votre profil est en revue.", ar: "ملفك قيد المراجعة."))
                        .font(KhedmaFont.hero(31))
                        .foregroundStyle(.white)
                    Text(preferences.language.copy(fr: "Une coordinatrice Khedma vérifie les documents, le portfolio, les services et les disponibilités avant l’accès aux demandes clientes.", ar: "ستراجع منسقة خدمة الوثائق، الأعمال، الخدمات، والمواعيد قبل فتح طلبات العميلات."))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.78))
                }
            }

            VStack(spacing: 12) {
                ApplicationStatusRow(status: .underReview, title: KhedmaCopy.applicationStatus(.underReview, language: preferences.language), detail: preferences.language.copy(fr: "Statut actuel. L’équipe vérifie le dossier.", ar: "الحالة الحالية. الفريق يراجع الملف."), isActive: true)
                ApplicationStatusRow(status: .verified, title: KhedmaCopy.applicationStatus(.verified, language: preferences.language), detail: preferences.language.copy(fr: "Les demandes s’ouvrent après approbation.", ar: "تُفتح الطلبات بعد الموافقة."), isActive: false)
                ApplicationStatusRow(status: .needMoreInfo, title: KhedmaCopy.applicationStatus(.needMoreInfo, language: preferences.language), detail: preferences.language.copy(fr: "Toute demande complémentaire apparaîtra ici.", ar: "أي طلب إضافي سيظهر هنا."), isActive: false)
            }
            .khedmaCard()

            Button(action: onComplete) {
                Text(preferences.language.copy(fr: "Continuer vers le profil", ar: "المتابعة إلى الملف"))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(LinearGradient(colors: [KhedmaTheme.accentDeep, KhedmaTheme.merlot], startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }

    private var localizedSelectedServices: String {
        selectedServices.sorted().map { id in
            let option = MockData.workerCategoryOptions.first { $0.id == id }
            return option.map { KhedmaCopy.selectableTitle($0, language: preferences.language) } ?? id
        }
        .joined(separator: ", ")
    }

    private func availabilityLabel(_ id: String) -> String {
        switch id {
        case "weekday-morning": return preferences.language.copy(fr: "Matins en semaine", ar: "صباح أيام الأسبوع")
        case "weekday-evening": return preferences.language.copy(fr: "Soirs en semaine", ar: "مساء أيام الأسبوع")
        case "saturday": return preferences.language.copy(fr: "Samedi", ar: "السبت")
        case "sunday": return preferences.language.copy(fr: "Dimanche", ar: "الأحد")
        case "same-day": return preferences.language.copy(fr: "Créneaux le jour même", ar: "مواعيد نفس اليوم")
        default: return id
        }
    }

    private func palette(for id: String) -> PortfolioPalette {
        switch id {
        case "id", "city": .ocean
        case "selfie", "submit": .gold
        case "services", "portfolio": .rose
        case "experience", "availability": .olive
        case "certs": .ink
        default: .clay
        }
    }
}

struct MockUploadPanel: View {
    let title: String
    let detail: String
    let symbol: String
    let palette: PortfolioPalette

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                VisualGradientBackground(palette: palette)
                Image(systemName: symbol)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 62, height: 62)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
            }
            Spacer()
            Image(systemName: "arrow.up.doc.fill")
                .foregroundStyle(KhedmaTheme.accentDeep)
        }
        .padding(14)
        .background(KhedmaTheme.surfaceWarm.opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

struct ApplicationStatusRow: View {
    let status: ApplicationStatus
    let title: String
    let detail: String
    let isActive: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.headline.weight(.bold))
                .foregroundStyle(isActive ? .white : KhedmaTheme.muted)
                .frame(width: 40, height: 40)
                .background(isActive ? KhedmaTheme.accentDeep : KhedmaTheme.surfaceWarm)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }

    private var symbol: String {
        switch status {
        case .underReview: "clock.badge.checkmark.fill"
        case .verified: "checkmark.seal.fill"
        case .needMoreInfo: "exclamationmark.bubble.fill"
        }
    }
}

struct ProfileCompletionOnboardingView: View {
    @EnvironmentObject private var preferences: AppPreferences
    let role: UserRole
    let onComplete: () -> Void
    @State private var name = "Lina Bennis"
    @State private var phone = "+212 6 12 34 56 78"
    @State private var address = "Maarif, près du Twin Center"
    @State private var paymentPreference = "Espèces après service"
    @State private var workerBio = "Professionnelle beauté ponctuelle, propre et attentive aux rendez-vous à domicile."
    @State private var pricingRange = "180-650 MAD"

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            OnboardingTitle(
                eyebrow: role == .customer ? "05" : "08",
                title: role == .customer ? preferences.language.copy(fr: "Finaliser le profil cliente", ar: "إكمال ملف العميلة") : preferences.language.copy(fr: "Finaliser le profil pro", ar: "إكمال ملف المهنية"),
                subtitle: role == .customer
                    ? preferences.language.copy(fr: "Quelques détails rendent la réservation plus fluide.", ar: "بعض التفاصيل تجعل الحجز أسهل.")
                    : preferences.language.copy(fr: "Ces éléments seront relus avant l’ouverture aux demandes clientes.", ar: "ستتم مراجعة هذه العناصر قبل فتح طلبات العميلات.")
            )

            if role == .customer {
                profileField(title: preferences.language.copy(fr: "Nom", ar: "الاسم"), text: $name, symbol: "person.fill")
                profileField(title: preferences.language.copy(fr: "Adresse préférée", ar: "العنوان المفضل"), text: $address, symbol: "house.fill")
                profileField(title: preferences.language.copy(fr: "Téléphone", ar: "الهاتف"), text: $phone, symbol: "phone.fill")
                profileField(title: preferences.language.copy(fr: "Paiement préféré", ar: "الدفع المفضل"), text: $paymentPreference, symbol: "creditcard.fill")
            } else {
                workerPhotoHeader
                profileField(title: preferences.language.copy(fr: "Bio", ar: "نبذة"), text: $workerBio, symbol: "text.quote")
                profileField(title: preferences.language.copy(fr: "Services", ar: "الخدمات"), text: .constant(preferences.language.copy(fr: "Ongles, maquillage, coiffure", ar: "أظافر، مكياج، شعر")), symbol: "sparkles")
                profileField(title: preferences.language.copy(fr: "Portfolio", ar: "الأعمال"), text: .constant(preferences.language.copy(fr: "3 exemples ajoutés", ar: "3 أمثلة مضافة")), symbol: "photo.stack.fill")
                profileField(title: preferences.language.copy(fr: "Disponibilité", ar: "التوفر"), text: .constant(preferences.language.copy(fr: "Semaine + samedi", ar: "أيام الأسبوع + السبت")), symbol: "calendar.badge.clock")
                profileField(title: preferences.language.copy(fr: "Fourchette de prix", ar: "نطاق السعر"), text: $pricingRange, symbol: "tag.fill")
            }

            PrimaryButton(title: role == .customer ? preferences.language.copy(fr: "Entrer dans Khedma", ar: "الدخول إلى خدمة") : preferences.language.copy(fr: "Ouvrir l’espace pro", ar: "فتح مساحة العمل"), subtitle: role == .customer ? preferences.language.copy(fr: "Commencer par Beauté à domicile", ar: "ابدئي بالجمال في المنزل") : preferences.language.copy(fr: "Suivre la revue et la force du profil", ar: "متابعة المراجعة وقوة الملف"), symbol: "arrow.right", action: onComplete)
        }
        .onAppear {
            name = preferences.language.copy(fr: "Lina Bennis", ar: "لينا بنيس")
            address = preferences.language.copy(fr: "Maarif, près du Twin Center", ar: "المعاريف، قرب توين سنتر")
            paymentPreference = KhedmaCopy.paymentMethod(.cash, language: preferences.language)
            workerBio = preferences.language.copy(fr: "Professionnelle beauté ponctuelle, propre et attentive aux rendez-vous à domicile.", ar: "مهنية جمال ملتزمة ونظيفة وتهتم بتجربة الموعد في المنزل.")
            pricingRange = preferences.language.copy(fr: "180-650 MAD", ar: "180-650 درهم")
        }
    }

    private var workerPhotoHeader: some View {
        HStack(spacing: 14) {
            ZStack {
                VisualGradientBackground(palette: .rose)
                Image(systemName: "person.crop.circle.fill.badge.plus")
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 88, height: 88)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            VStack(alignment: .leading, spacing: 6) {
                Text(preferences.language.copy(fr: "Photo de profil", ar: "صورة الملف"))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(preferences.language.copy(fr: "Une photo claire renforce la confiance après approbation.", ar: "صورة واضحة تزيد ثقة العميلات بعد الموافقة."))
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
            }
            Spacer()
        }
        .khedmaCard()
    }

    private func profileField(title: String, text: Binding<String>, symbol: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.headline.weight(.bold))
                .foregroundStyle(KhedmaTheme.accentDeep)
                .frame(width: 42, height: 42)
                .background(KhedmaTheme.surfaceWarm)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(KhedmaTheme.muted)
                TextField(title, text: text)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(KhedmaTheme.ink)
            }
        }
        .padding(14)
        .background(KhedmaTheme.surface.opacity(0.86))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(.white.opacity(0.7), lineWidth: 1))
    }
}
