import SwiftUI

private enum AppOnboardingStep: Int, CaseIterable {
    case language
    case welcome
    case role
    case categories
    case location
    case workerIntro
    case workerApplication
    case profileCompletion
}

struct AppOnboardingFlowView: View {
    @EnvironmentObject private var preferences: AppPreferences
    @State private var step: AppOnboardingStep = .language
    @State private var selectedRole: UserRole = .customer
    @State private var selectedIDs: Set<String> = ["beauty"]
    @State private var city = "Casablanca"
    @State private var neighborhood = "Maarif"
    @State private var showVerificationDetails = false

    var body: some View {
        ZStack {
            KhedmaBackground()
            VStack(spacing: 0) {
                topProgress
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        stepContent
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 10)
                    .padding(.bottom, bottomPadding)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if showsBottomCTA {
                bottomCTA
            }
        }
        .onAppear {
            selectedRole = preferences.role ?? .customer
            selectedIDs = Set(preferences.selectedInterestIDs.isEmpty ? ["beauty"] : preferences.selectedInterestIDs)
            city = preferences.city
            neighborhood = preferences.neighborhood
            normalizeSelections()
            normalizeLaunchCity()
        }
    }

    private var topProgress: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Khedma")
                    .font(.headline.weight(.black))
                    .foregroundStyle(KhedmaTheme.ink)
                Spacer()
                if step != .language {
                    Button {
                        withAnimation(.snappy) {
                            goBack()
                        }
                    } label: {
                        Text(copy("Retour", ar: "رجوع"))
                            .font(.caption.weight(.bold))
                            .foregroundStyle(KhedmaTheme.accentDeep)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(KhedmaTheme.surface.opacity(0.78))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }

            HStack(spacing: 6) {
                ForEach(0..<visibleStepCount, id: \.self) { index in
                    Capsule()
                        .fill(index <= progressIndex ? KhedmaTheme.accentDeep : KhedmaTheme.line.opacity(0.8))
                        .frame(height: 5)
                        .animation(.snappy, value: progressIndex)
                }
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private var stepContent: some View {
        switch step {
        case .language:
            languageScreen
        case .welcome:
            welcomeScreen
        case .role:
            roleScreen
        case .categories:
            categoryScreen
        case .location:
            locationScreen
        case .workerIntro:
            workerIntroScreen
        case .workerApplication:
            WorkerVerificationFlow {
                preferences.workerApplicationStatus = .underReview
                withAnimation(.snappy) {
                    step = .profileCompletion
                }
            }
        case .profileCompletion:
            ProfileCompletionOnboardingView(role: selectedRole) {
                saveSelections()
                preferences.completeOnboarding()
            }
        }
    }

    private var welcomeScreen: some View {
        VStack(alignment: .leading, spacing: 16) {
            PremiumHeroCard(palette: .ink) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        TrustPill(text: copy("Maroc d’abord", ar: "تجربة مغربية"), symbol: "mappin.and.ellipse", tint: .white)
                        Spacer()
                    }

                    OnboardingIllustration(compact: true)
                        .frame(height: 164)
                        .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(copy("Services locaux de confiance, sélectionnés pour le Maroc.", ar: "خدمات محلية موثوقة ومنتقاة للمغرب."))
                            .font(KhedmaFont.hero(29))
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(copy("Réservez des professionnelles vérifiées ou postulez sur une plateforme bâtie autour de la réputation, du suivi et de la qualité.", ar: "احجزي مقدّمات موثوقات أو قدّمي طلبك للعمل ضمن منصة مبنية على السمعة والدعم والجودة."))
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white.opacity(0.78))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    HStack(spacing: 8) {
                        WorkerHeroBadge(title: copy("contrôles", ar: "تحقق"), value: "3")
                        WorkerHeroBadge(title: copy("ville", ar: "مدينة"), value: copy("Casa", ar: "كازا"))
                        WorkerHeroBadge(title: copy("lancement", ar: "إطلاق"), value: copy("Beauté", ar: "جمال"))
                    }
                }
            }
        }
    }

    private var languageScreen: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 14) {
                    Image(systemName: "globe.europe.africa.fill")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 46, height: 46)
                        .background(KhedmaTheme.accentDeep)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    VStack(alignment: .leading, spacing: 8) {
                        Text(copy("Choisissez votre langue", ar: "اختاري اللغة"))
                            .font(KhedmaFont.hero(24))
                            .foregroundStyle(KhedmaTheme.ink)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(copy("Toute l’expérience Khedma suivra ce choix: navigation, réservation, assistance et profil.", ar: "ستظهر تجربة خدمة كاملة بهذه اللغة: التنقل، الحجز، المساعدة والملف."))
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(KhedmaTheme.muted)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 0)
                }
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundStyle(KhedmaTheme.olive)
                    Text(copy("Modifiable plus tard dans le profil.", ar: "يمكن تغييره لاحقًا من الملف."))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(KhedmaTheme.olive)
                }
                .padding(.horizontal, 11)
                .padding(.vertical, 8)
                .background(KhedmaTheme.olive.opacity(0.10))
                .clipShape(Capsule())
            }
            .khedmaCard(padding: 14)

            Text(copy("Langue de l’application", ar: "لغة التطبيق"))
                .font(.headline.weight(.bold))
                .foregroundStyle(KhedmaTheme.ink)

            ForEach(KhedmaLanguage.allCases) { language in
                Button {
                    preferences.language = language
                    triggerSoftHaptic()
                } label: {
                    HStack(spacing: 16) {
                        Text(language == .arabic ? "ع" : "Fr")
                            .font(.title3.weight(.black))
                            .foregroundStyle(.white)
                            .frame(width: 52, height: 52)
                            .background(VisualGradientBackground(palette: language == .arabic ? .gold : .ocean))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        VStack(alignment: .leading, spacing: 5) {
                            Text(language.displayName)
                                .font(.title3.weight(.bold))
                                .foregroundStyle(KhedmaTheme.ink)
                            Text(language.headline)
                                .font(.subheadline)
                                .foregroundStyle(KhedmaTheme.muted)
                        }
                        Spacer()
                        Image(systemName: preferences.language == language ? "checkmark.circle.fill" : "circle")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(preferences.language == language ? KhedmaTheme.success : KhedmaTheme.line)
                    }
                    .padding(14)
                    .premiumSurface(cornerRadius: 22)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var roleScreen: some View {
        VStack(alignment: .leading, spacing: 18) {
            OnboardingTitle(
                eyebrow: "02",
                title: copy("Comment souhaitez-vous utiliser Khedma ?", ar: "كيف تريدين استخدام خدمة؟"),
                subtitle: copy("Commencez par réserver des services ou rejoindre la sélection professionnelle.", ar: "اختاري طريقة البداية، للحجز أو للعمل مع خدمة.")
            )

            Button {
                selectRole(.customer)
            } label: {
                PremiumSelectableCard(
                    title: copy("Je veux réserver des services", ar: "أريد حجز خدمات"),
                    subtitle: copy("Trouver des professionnelles vérifiées à domicile.", ar: "احجزي مقدّمات موثوقات لخدمات المنزل."),
                    symbol: "calendar.badge.plus",
                    palette: .rose,
                    isSelected: selectedRole == .customer
                )
            }
            .buttonStyle(.plain)

            Button {
                selectRole(.worker)
            } label: {
                PremiumSelectableCard(
                    title: copy("Je veux travailler avec Khedma", ar: "أريد العمل مع خدمة"),
                    subtitle: copy("Postuler pour rejoindre une sélection fondée sur la réputation.", ar: "قدّمي طلبك للانضمام إلى شبكة موثوقة ومنتقاة."),
                    symbol: "briefcase.fill",
                    palette: .ocean,
                    isSelected: selectedRole == .worker
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var categoryScreen: some View {
        VStack(alignment: .leading, spacing: 18) {
            OnboardingTitle(
                eyebrow: "03",
                title: selectedRole == .customer
                    ? copy("Quels services vous intéressent ?", ar: "ما الخدمات التي تهمك؟")
                    : copy("Quel type de travail souhaitez-vous faire ?", ar: "ما نوع العمل الذي تريدين القيام به؟"),
                subtitle: selectedRole == .customer
                    ? copy("La beauté à domicile est disponible maintenant. Les autres choix guident les prochains lancements.", ar: "الجمال المنزلي متاح الآن. الخيارات الأخرى توجه الإطلاقات القادمة.")
                    : copy("Choisissez une ou plusieurs catégories pour votre candidature.", ar: "اختاري فئة أو أكثر لطلب الانضمام.")
            )

            if selectedRole == .customer {
                VStack(spacing: 14) {
                    if let launchOption = categoryOptions.first {
                        Button {
                            toggle(launchOption.id)
                        } label: {
                            OnboardingMiniOption(option: launchOption, isSelected: selectedIDs.contains(launchOption.id))
                        }
                        .buttonStyle(.plain)
                    }

                    let futureOptions = Array(categoryOptions.dropFirst())
                    let columns = [GridItem(.flexible(), spacing: 18), GridItem(.flexible(), spacing: 18)]
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(futureOptions) { option in
                            OnboardingMiniOption(
                                option: option,
                                isSelected: false,
                                compact: true,
                                isLocked: true
                            )
                            .accessibilityLabel("\(KhedmaCopy.selectableTitle(option, language: preferences.language)), \(copy("bientôt disponible", ar: "قريبًا"))")
                        }
                    }
                }
            } else {
                let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(categoryOptions) { option in
                        Button {
                            toggle(option.id)
                        } label: {
                            OnboardingMiniOption(option: option, isSelected: selectedIDs.contains(option.id), compact: true)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var locationScreen: some View {
        VStack(alignment: .leading, spacing: 18) {
            OnboardingTitle(
                eyebrow: "04",
                title: copy("Où Khedma doit-elle commencer pour vous ?", ar: "أين تريدين أن تبدأ خدمة معك؟"),
                subtitle: copy("Casablanca est la ville de lancement. Le quartier garde les propositions proches et utiles.", ar: "الدار البيضاء هي مدينة الإطلاق. الحي يساعدنا على اختيار أفضل.")
            )

            VStack(alignment: .leading, spacing: 14) {
                Text(copy("Ville", ar: "المدينة"))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                HStack(spacing: 10) {
                    ForEach(MockData.cities, id: \.self) { cityOption in
                        if cityOption == "Casablanca" {
                            Button {
                                city = cityOption
                                neighborhood = MockData.neighborhoodsByCity[cityOption]?.first ?? ""
                                preferences.city = city
                                preferences.neighborhood = neighborhood
                                triggerSoftHaptic()
                            } label: {
                                CityAvailabilityChip(
                                    title: KhedmaCopy.city(cityOption, language: preferences.language),
                                    status: copy("Lancement", ar: "الإطلاق"),
                                    isSelected: city == cityOption,
                                    isAvailable: true
                                )
                            }
                            .buttonStyle(.plain)
                        } else {
                            CityAvailabilityChip(
                                title: KhedmaCopy.city(cityOption, language: preferences.language),
                                status: copy("Bientôt", ar: "قريبًا"),
                                isSelected: false,
                                isAvailable: false
                            )
                            .accessibilityLabel("\(KhedmaCopy.city(cityOption, language: preferences.language)), \(copy("bientôt disponible", ar: "قريبًا"))")
                        }
                    }
                }
            }
            .khedmaCard()

            VStack(alignment: .leading, spacing: 14) {
                Text(copy("Quartier", ar: "الحي"))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                let columns = [GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(MockData.neighborhoodsByCity[city] ?? [], id: \.self) { area in
                        Button {
                            neighborhood = area
                            preferences.neighborhood = area
                            triggerSoftHaptic()
                        } label: {
                            HStack {
                                Text(KhedmaCopy.neighborhood(area, language: preferences.language))
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(neighborhood == area ? .white : KhedmaTheme.ink)
                                Spacer()
                                if neighborhood == area {
                                    Image(systemName: "checkmark")
                                        .font(.caption.weight(.black))
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(14)
                            .background(neighborhood == area ? KhedmaTheme.accentDeep : KhedmaTheme.surface.opacity(0.82))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .khedmaCard()
        }
    }

    private var workerIntroScreen: some View {
        VStack(alignment: .leading, spacing: 20) {
            PremiumHeroCard(palette: .ocean) {
                VStack(alignment: .leading, spacing: 18) {
                    TrustPill(text: copy("Sélection contrôlée", ar: "شبكة منتقاة"), symbol: "checkmark.shield.fill", tint: .white)
                    Image(systemName: "person.crop.rectangle.stack.fill")
                        .font(.system(size: 64, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.9))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Text(copy("Khedma n’est pas une inscription ouverte.", ar: "خدمة ليست تسجيلًا مفتوحًا."))
                        .font(KhedmaFont.hero(31))
                        .foregroundStyle(.white)
                    Text(copy("Les professionnelles construisent leur réputation dans le temps. Avant les demandes clientes, chaque profil passe par une revue identité, portfolio, services et équipe.", ar: "كل ملف يمر بالهوية، الأعمال السابقة، الخدمات، ومراجعة فريق خدمة قبل استقبال طلبات العميلات."))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.78))
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                VerificationPoint(title: copy("Vérification identité", ar: "التحقق من الهوية"), detail: copy("Pièce d’identité et selfie.", ar: "بطاقة الهوية وصورة شخصية."), symbol: "person.text.rectangle.fill")
                VerificationPoint(title: copy("Revue portfolio", ar: "مراجعة الأعمال"), detail: copy("Exemples clairs de travaux réalisés.", ar: "أمثلة واضحة للأعمال المنجزة."), symbol: "photo.stack.fill")
                VerificationPoint(title: copy("Entretien équipe", ar: "مقابلة مع الفريق"), detail: copy("Qualité, ponctualité et conduite à domicile.", ar: "الجودة، الالتزام، والتعامل داخل المنزل."), symbol: "message.fill")
            }
            .khedmaCard()

            Button {
                withAnimation(.snappy) {
                    showVerificationDetails.toggle()
                }
            } label: {
                Text(showVerificationDetails ? copy("Masquer les détails", ar: "إخفاء التفاصيل") : copy("Comprendre la vérification", ar: "كيف يعمل التحقق؟"))
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.accentDeep)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(KhedmaTheme.surface.opacity(0.82))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .buttonStyle(.plain)

            if showVerificationDetails {
                Text(copy("L’équipe Khedma relit les candidatures manuellement. Certaines catégories, comme l’électricité ou la plomberie, peuvent demander des certificats avant validation.", ar: "يقوم فريق خدمة بمراجعة الطلبات يدويًا. بعض الفئات مثل الكهرباء أو السباكة قد تحتاج وثائق إضافية قبل التوثيق."))
                    .font(.subheadline)
                    .foregroundStyle(KhedmaTheme.muted)
                    .khedmaCard()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    private var bottomCTA: some View {
        VStack(spacing: 0) {
            Divider().overlay(KhedmaTheme.line.opacity(0.5))
            Button {
                withAnimation(.snappy) {
                    advance()
                }
                triggerSoftHaptic()
            } label: {
                Text(bottomTitle)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(
                        LinearGradient(colors: [KhedmaTheme.accentDeep, KhedmaTheme.merlot, KhedmaTheme.clay], startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: KhedmaTheme.accentDeep.opacity(0.24), radius: 18, x: 0, y: 12)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 22)
            .padding(.vertical, 14)
            .background(KhedmaTheme.background.opacity(0.96))
        }
    }

    private var bottomTitle: String {
        switch step {
        case .language: copy("Continuer", ar: "متابعة")
        case .welcome: copy("Continuer", ar: "متابعة")
        case .role: copy("Continuer", ar: "متابعة")
        case .categories: copy("Continuer", ar: "متابعة")
        case .location: selectedRole == .worker ? copy("Continuer vers la vérification", ar: "المتابعة إلى التحقق") : copy("Compléter le profil", ar: "إكمال الملف")
        case .workerIntro: copy("Commencer la candidature", ar: "بدء الطلب")
        case .workerApplication, .profileCompletion: ""
        }
    }

    private var showsBottomCTA: Bool {
        step != .workerApplication && step != .profileCompletion
    }

    private var bottomPadding: CGFloat {
        showsBottomCTA ? 120 : 36
    }

    private var progressIndex: Int {
        min(step.rawValue, visibleStepCount - 1)
    }

    private var visibleStepCount: Int {
        selectedRole == .worker ? 8 : 6
    }

    private var categoryOptions: [SelectableOption] {
        selectedRole == .customer ? MockData.customerInterestOptions : MockData.workerCategoryOptions
    }

    private func copy(_ fr: String, ar: String) -> String {
        preferences.language == .arabic ? ar : fr
    }

    private func selectRole(_ role: UserRole) {
        selectedRole = role
        selectedIDs = role == .customer ? ["beauty"] : []
        preferences.role = role
        preferences.selectedInterestIDs = Array(selectedIDs)
        triggerSoftHaptic()
    }

    private func toggle(_ id: String) {
        if selectedRole == .customer, id != "beauty" {
            return
        }
        if selectedIDs.contains(id) {
            selectedIDs.remove(id)
        } else {
            selectedIDs.insert(id)
        }
        if selectedRole == .customer, selectedIDs.isEmpty {
            selectedIDs.insert("beauty")
        }
        preferences.selectedInterestIDs = Array(selectedIDs)
        triggerSoftHaptic()
    }

    private func advance() {
        switch step {
        case .language:
            step = .welcome
        case .welcome:
            step = .role
        case .role:
            step = .categories
        case .categories:
            step = .location
        case .location:
            step = selectedRole == .worker ? .workerIntro : .profileCompletion
        case .workerIntro:
            step = .workerApplication
        case .workerApplication, .profileCompletion:
            break
        }
    }

    private func goBack() {
        switch step {
        case .language:
            break
        case .welcome:
            step = .language
        case .role:
            step = .welcome
        case .categories:
            step = .role
        case .location:
            step = .categories
        case .workerIntro:
            step = .location
        case .workerApplication:
            step = .workerIntro
        case .profileCompletion:
            step = selectedRole == .worker ? .workerApplication : .location
        }
    }

    private func saveSelections() {
        normalizeSelections()
        normalizeLaunchCity()
        preferences.role = selectedRole
        preferences.selectedInterestIDs = Array(selectedIDs)
        preferences.city = city
        preferences.neighborhood = neighborhood
    }

    private func normalizeSelections() {
        let validIDs = Set(categoryOptions.map(\.id))
        selectedIDs = selectedIDs.intersection(validIDs)
        if selectedRole == .customer {
            selectedIDs = ["beauty"]
        }
        preferences.selectedInterestIDs = Array(selectedIDs)
    }

    private func normalizeLaunchCity() {
        guard city != "Casablanca" else { return }
        city = "Casablanca"
        neighborhood = MockData.neighborhoodsByCity["Casablanca"]?.first ?? "Maarif"
        preferences.city = city
        preferences.neighborhood = neighborhood
    }
}

struct OnboardingTitle: View {
    let eyebrow: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(eyebrow)
                .font(.caption.weight(.black))
                .foregroundStyle(KhedmaTheme.gold)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(KhedmaTheme.ink)
                .clipShape(Capsule())
            Text(title)
                .font(KhedmaFont.hero(31))
                .foregroundStyle(KhedmaTheme.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text(subtitle)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(KhedmaTheme.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct OnboardingIllustration: View {
    @EnvironmentObject private var preferences: AppPreferences
    var compact = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: compact ? 28 : 34, style: .continuous)
                .fill(.white.opacity(0.12))
                .overlay(MoroccanPattern().stroke(.white.opacity(0.12), lineWidth: 1))
            VStack(spacing: compact ? 9 : 16) {
                HStack(spacing: compact ? 9 : 14) {
                    MiniServicePhoto(symbol: "sparkles", label: preferences.language.copy(fr: "Beauté", ar: "جمال"), palette: .rose, width: compact ? 96 : 118, height: compact ? 58 : 86, cornerRadius: compact ? 18 : 24)
                    MiniServicePhoto(symbol: "hands.sparkles.fill", label: preferences.language.copy(fr: "Suivi", ar: "متابعة"), palette: .olive, width: compact ? 96 : 118, height: compact ? 58 : 86, cornerRadius: compact ? 18 : 24)
                }
                HStack(spacing: compact ? 9 : 14) {
                    MiniServicePhoto(symbol: "checkmark.seal.fill", label: preferences.language.copy(fr: "Vérifié", ar: "موثوق"), palette: .gold, width: compact ? 96 : 118, height: compact ? 58 : 86, cornerRadius: compact ? 18 : 24)
                    MiniServicePhoto(symbol: "message.fill", label: preferences.language.copy(fr: "Équipe", ar: "الفريق"), palette: .ocean, width: compact ? 96 : 118, height: compact ? 58 : 86, cornerRadius: compact ? 18 : 24)
                }
            }
            .rotationEffect(.degrees(-3))
        }
    }
}

struct MiniServicePhoto: View {
    let symbol: String
    let label: String
    let palette: PortfolioPalette
    var width: CGFloat = 118
    var height: CGFloat = 86
    var cornerRadius: CGFloat = 24

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: symbol)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
            Spacer()
            Text(label)
                .font(.caption.weight(.black))
                .foregroundStyle(.white)
        }
        .padding(height < 70 ? 9 : 12)
        .frame(width: width, height: height, alignment: .leading)
        .background(VisualGradientBackground(palette: palette))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).stroke(.white.opacity(0.35), lineWidth: 1))
        .shadow(color: .black.opacity(0.14), radius: 16, x: 0, y: 10)
    }
}

struct LanguagePreviewPill: View {
    let title: String
    let initials: String

    var body: some View {
        HStack(spacing: 7) {
            Text(initials)
                .font(.caption2.weight(.black))
                .foregroundStyle(KhedmaTheme.ink)
                .frame(width: 28, height: 28)
                .background(.white.opacity(0.9))
                .clipShape(Circle())
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.88))
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(.white.opacity(0.13))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(.white.opacity(0.18), lineWidth: 1))
    }
}

struct OnboardingMiniOption: View {
    @EnvironmentObject private var preferences: AppPreferences
    let option: SelectableOption
    let isSelected: Bool
    var compact = false
    var isLocked = false

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 10 : 12) {
            ZStack {
                VisualGradientBackground(palette: option.palette)
                Image(systemName: option.symbol)
                    .font((compact ? Font.headline : Font.title2).weight(.semibold))
                    .foregroundStyle(.white)
                if isLocked {
                    LockedOptionWatermark(label: preferences.language.copy(fr: "VERROUILLÉ", ar: "مغلق"))
                }
            }
            .frame(height: compact ? 66 : 82)
            .clipShape(RoundedRectangle(cornerRadius: compact ? 18 : 22, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(KhedmaCopy.selectableTitle(option, language: preferences.language))
                    .font((compact ? Font.subheadline : Font.headline).weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                    .lineLimit(2)
                    .minimumScaleFactor(0.86)
                Text(KhedmaCopy.selectableSubtitle(option, language: preferences.language))
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
                    .lineLimit(compact ? 3 : 2)
                    .minimumScaleFactor(0.86)
            }

            HStack {
                Text(statusText)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(statusColor)
                Spacer()
                Image(systemName: statusSymbol)
                    .foregroundStyle(statusColor.opacity(isLocked ? 0.70 : 1))
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: compact ? 176 : 208, alignment: .topLeading)
        .background(isSelected ? KhedmaTheme.accent.opacity(0.09) : KhedmaTheme.surface.opacity(isLocked ? 0.70 : 0.82))
        .clipShape(RoundedRectangle(cornerRadius: compact ? 22 : 26, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: compact ? 22 : 26, style: .continuous).stroke(isSelected ? KhedmaTheme.accent.opacity(0.55) : (isLocked ? KhedmaTheme.line.opacity(0.50) : .white.opacity(0.66)), lineWidth: 1))
        .overlay(alignment: .topTrailing) {
            if isLocked {
                HStack(spacing: 5) {
                    Image(systemName: "lock.fill")
                    Text(preferences.language.copy(fr: "Bientôt", ar: "قريبًا"))
                }
                .font(.caption2.weight(.black))
                .foregroundStyle(KhedmaTheme.accentDeep.opacity(0.78))
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .background(KhedmaTheme.surface.opacity(0.86))
                .clipShape(Capsule())
                .padding(9)
            }
        }
        .shadow(color: isSelected ? KhedmaTheme.accent.opacity(0.09) : KhedmaTheme.ink.opacity(compact ? 0.025 : 0.04), radius: compact ? 6 : 14, x: 0, y: compact ? 4 : 8)
    }

    private var statusText: String {
        if isLocked { return preferences.language.copy(fr: "Verrouillé", ar: "مغلق") }
        return isSelected ? preferences.language.copy(fr: "Sélectionné", ar: "مختار") : preferences.language.copy(fr: "Choisir", ar: "اختيار")
    }

    private var statusSymbol: String {
        if isLocked { return "lock.fill" }
        return isSelected ? "checkmark.circle.fill" : "circle"
    }

    private var statusColor: Color {
        if isLocked { return KhedmaTheme.muted }
        return isSelected ? KhedmaTheme.success : KhedmaTheme.muted
    }
}

private struct LockedOptionWatermark: View {
    let label: String

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.12))
            HStack(spacing: 7) {
                Image(systemName: "lock.fill")
                Text(label)
            }
            .font(.caption.weight(.black))
            .foregroundStyle(.white.opacity(0.84))
            .tracking(1.4)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(.white.opacity(0.16))
            .clipShape(Capsule())
            .rotationEffect(.degrees(-9))
        }
    }
}

struct CityAvailabilityChip: View {
    let title: String
    let status: String
    let isSelected: Bool
    let isAvailable: Bool

    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.caption.weight(.black))
                .lineLimit(1)
                .minimumScaleFactor(0.78)
            Text(status)
                .font(.system(size: 10, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.62)
                .allowsTightening(true)
                .opacity(isAvailable ? 0.85 : 0.66)
        }
        .foregroundStyle(isSelected ? .white : (isAvailable ? KhedmaTheme.ink : KhedmaTheme.muted))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 11)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(isSelected ? KhedmaTheme.accentDeep : KhedmaTheme.surface.opacity(isAvailable ? 0.86 : 0.58))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(isSelected ? KhedmaTheme.gold.opacity(0.45) : KhedmaTheme.line.opacity(isAvailable ? 0.55 : 0.35), lineWidth: 1)
        }
        .overlay(alignment: .topTrailing) {
            if !isAvailable {
                Image(systemName: "lock.fill")
                    .font(.caption2.weight(.black))
                    .foregroundStyle(KhedmaTheme.muted.opacity(0.55))
                    .padding(7)
            }
        }
    }
}

struct VerificationPoint: View {
    let title: String
    let detail: String
    let symbol: String

    var body: some View {
        HStack(spacing: 13) {
            Image(systemName: symbol)
                .font(.headline.weight(.semibold))
                .foregroundStyle(KhedmaTheme.accentDeep)
                .frame(width: 42, height: 42)
                .background(KhedmaTheme.surfaceWarm)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
            }
            Spacer()
        }
    }
}

#Preview("New Onboarding") {
    AppOnboardingFlowView()
        .environmentObject(AppPreferences.previewOnboarding)
        .preferredColorScheme(.light)
}
