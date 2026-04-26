import SwiftUI

enum KhedmaCopy {
    static func text(_ language: KhedmaLanguage, fr: String, ar: String) -> String {
        language == .arabic ? ar : fr
    }

    static func city(_ city: String, language: KhedmaLanguage) -> String {
        guard language == .arabic else { return city }
        switch city {
        case "Casablanca": return "الدار البيضاء"
        case "Rabat": return "الرباط"
        case "Marrakech": return "مراكش"
        default: return city
        }
    }

    static func neighborhood(_ neighborhood: String, language: KhedmaLanguage) -> String {
        guard language == .arabic else { return neighborhood }
        switch neighborhood {
        case "Maarif": return "المعاريف"
        case "Gauthier": return "غوتيي"
        case "Californie": return "كاليفورني"
        case "Anfa": return "أنفا"
        case "Bourgogne": return "بوركون"
        case "CIL": return "سي آي إل"
        case "Agdal": return "أكدال"
        case "Hay Riad": return "حي الرياض"
        case "Souissi": return "السويسي"
        case "Hassan": return "حسان"
        case "Gueliz": return "كيليز"
        case "Hivernage": return "إيفرناج"
        case "Majorelle": return "ماجوريل"
        case "Targa": return "تاركة"
        default: return neighborhood
        }
    }

    static func tab(_ tab: AppTab, role: UserRole?, language: KhedmaLanguage) -> String {
        switch tab {
        case .home:
            return text(language, fr: role == .worker ? "Espace pro" : "Accueil", ar: role == .worker ? "مساحة العمل" : "الرئيسية")
        case .bookings:
            return text(language, fr: role == .worker ? "Demandes" : "Réservations", ar: role == .worker ? "الطلبات" : "الحجوزات")
        case .favorites:
            return text(language, fr: "Favoris", ar: "المفضلة")
        case .support:
            return text(language, fr: "Assistance", ar: "المساعدة")
        case .profile:
            return text(language, fr: "Profil", ar: "الملف")
        }
    }

    static func roleTitle(_ role: UserRole, language: KhedmaLanguage) -> String {
        switch role {
        case .customer: return text(language, fr: "Cliente", ar: "عميلة")
        case .worker: return text(language, fr: "Professionnelle", ar: "مهنية")
        }
    }

    static func applicationStatus(_ status: ApplicationStatus, language: KhedmaLanguage) -> String {
        switch status {
        case .underReview: return text(language, fr: "En revue", ar: "قيد المراجعة")
        case .verified: return text(language, fr: "Vérifiée", ar: "موثقة")
        case .needMoreInfo: return text(language, fr: "Infos requises", ar: "معلومات إضافية")
        }
    }

    static func specialty(_ specialty: BeautySpecialty, language: KhedmaLanguage) -> String {
        switch specialty {
        case .nails: return text(language, fr: "Ongles", ar: "الأظافر")
        case .hair: return text(language, fr: "Coiffure", ar: "الشعر")
        case .makeup: return text(language, fr: "Maquillage", ar: "المكياج")
        case .browsLashes: return text(language, fr: "Sourcils & cils", ar: "الحواجب والرموش")
        }
    }

    static func categoryName(_ category: BeautyCategory, language: KhedmaLanguage) -> String {
        switch category.id {
        case "nails": return specialty(.nails, language: language)
        case "hair": return text(language, fr: "Coiffure à domicile", ar: "تصفيف الشعر في المنزل")
        case "makeup": return specialty(.makeup, language: language)
        case "brows": return specialty(.browsLashes, language: language)
        default: return category.name
        }
    }

    static func departmentTitle(_ department: Department, language: KhedmaLanguage) -> String {
        switch department.id {
        case "beauty": return text(language, fr: "Beauté à domicile", ar: "الجمال في المنزل")
        case "helpers": return text(language, fr: "Aide à la maison", ar: "مساعدة منزلية")
        case "trades": return text(language, fr: "Métiers qualifiés", ar: "حرف موثوقة")
        case "transport": return text(language, fr: "Trajets pour femmes", ar: "تنقلات مخصصة للنساء")
        default: return department.title
        }
    }

    static func departmentSubtitle(_ department: Department, language: KhedmaLanguage) -> String {
        switch department.status {
        case .active: return text(language, fr: "Disponible à Casablanca", ar: "متاح في الدار البيضاء")
        case .comingSoon: return text(language, fr: "Bientôt disponible", ar: "قريبًا")
        }
    }

    static func selectableTitle(_ option: SelectableOption, language: KhedmaLanguage) -> String {
        switch option.id {
        case "beauty": return text(language, fr: "Beauté à domicile", ar: "الجمال في المنزل")
        case "helpers": return text(language, fr: "Aide à la maison", ar: "مساعدة منزلية")
        case "trades": return text(language, fr: "Métiers qualifiés", ar: "حرف موثوقة")
        case "nails": return specialty(.nails, language: language)
        case "hair": return specialty(.hair, language: language)
        case "makeup": return specialty(.makeup, language: language)
        case "cleaning": return text(language, fr: "Nettoyage", ar: "التنظيف")
        case "plumbing": return text(language, fr: "Plomberie", ar: "السباكة")
        case "woodwork": return text(language, fr: "Menuiserie", ar: "النجارة")
        case "zellige": return text(language, fr: "Zellige / carrelage", ar: "زليج / تبليط")
        case "electrical": return text(language, fr: "Électricité", ar: "الكهرباء")
        default: return option.title
        }
    }

    static func selectableSubtitle(_ option: SelectableOption, language: KhedmaLanguage) -> String {
        switch option.id {
        case "beauty": return text(language, fr: "Ongles, coiffure, maquillage", ar: "أظافر، شعر، ومكياج")
        case "helpers": return text(language, fr: "Aide fiable, bientôt", ar: "دعم منزلي موثوق قريبًا")
        case "trades": return text(language, fr: "Plombier, électricien, petites réparations", ar: "سبّاك، كهربائي، وإصلاحات منزلية")
        case "nails": return text(language, fr: "Manucure, gel, pédicure", ar: "مانيكير، جل، وباديكير")
        case "hair": return text(language, fr: "Brushing, waves, chignon", ar: "براشينغ، تمويج، وشينيون")
        case "makeup": return text(language, fr: "Mise en beauté et événements", ar: "مكياج ناعم ومناسبات")
        case "cleaning": return text(language, fr: "Future ligne maison", ar: "فئة منزلية لاحقًا")
        case "plumbing": return text(language, fr: "Réparations et installations", ar: "إصلاحات وتركيبات")
        case "woodwork": return text(language, fr: "Petits travaux de bois", ar: "أعمال نجارة صغيرة")
        case "zellige": return text(language, fr: "Finitions et carrelage", ar: "زليج وتشطيبات")
        case "electrical": return text(language, fr: "Travail licencié uniquement", ar: "أعمال مرخصة فقط")
        default: return option.subtitle
        }
    }

    static func beautyFilter(_ filter: BeautyFilter, language: KhedmaLanguage) -> String {
        switch filter {
        case .nails: return specialty(.nails, language: language)
        case .hair: return specialty(.hair, language: language)
        case .makeup: return specialty(.makeup, language: language)
        case .availableToday: return text(language, fr: "Aujourd’hui", ar: "اليوم")
        case .nearMe: return text(language, fr: "Près de moi", ar: "قريب مني")
        case .under250: return text(language, fr: "Moins de 250 MAD", ar: "أقل من 250 درهم")
        case .under350: return text(language, fr: "Moins de 350 MAD", ar: "أقل من 350 درهم")
        case .verifiedOnly: return text(language, fr: "Profils vérifiés", ar: "ملفات موثقة")
        }
    }

    static func beautySort(_ sort: BeautySortOption, language: KhedmaLanguage) -> String {
        switch sort {
        case .recommended: return text(language, fr: "Recommandées", ar: "موصى به")
        case .earliest: return text(language, fr: "Créneau le plus proche", ar: "أقرب موعد")
        case .topRated: return text(language, fr: "Mieux notées", ar: "الأعلى تقييمًا")
        case .lowestPrice: return text(language, fr: "Prix le plus bas", ar: "أقل سعر")
        }
    }

    static func bookingStatus(_ status: BookingStatus, language: KhedmaLanguage) -> String {
        switch status {
        case .upcoming: return text(language, fr: "À venir", ar: "قادمة")
        case .past: return text(language, fr: "Passées", ar: "سابقة")
        case .cancelled: return text(language, fr: "Annulées", ar: "ملغاة")
        }
    }

    static func paymentMethod(_ method: PaymentMethod, language: KhedmaLanguage) -> String {
        switch method {
        case .cash: return text(language, fr: "Espèces après service", ar: "نقدًا بعد الخدمة")
        case .card: return text(language, fr: "Carte", ar: "بطاقة")
        }
    }

    static func providerBadge(_ badge: ProviderBadge, language: KhedmaLanguage) -> String {
        switch badge {
        case .topRated: return text(language, fr: "Très appréciée", ar: "مفضلة جدًا")
        case .repeatFavorite: return text(language, fr: "Cliente fidèle", ar: "حجوزات متكررة")
        case .fastResponse: return text(language, fr: "Réponse rapide", ar: "رد سريع")
        }
    }

    static func providerName(_ provider: Provider, language: KhedmaLanguage) -> String {
        guard language == .arabic else { return provider.name }
        switch provider.id {
        case "yasmina": return "ياسمينة العمراني"
        case "imanes": return "إيمان السعيدي"
        case "soukaina": return "سكينة بناني"
        case "najat": return "نجاة الفاسي"
        case "fatima": return "فاطمة الزهراء القادري"
        case "hiba": return "هبة العلوي"
        case "asmae": return "أسماء لحلو"
        case "malika": return "مليكة الرامي"
        default: return provider.name
        }
    }

    static func providerBio(_ provider: Provider, language: KhedmaLanguage) -> String {
        switch provider.id {
        case "yasmina": return text(language, fr: "Yasmina est reconnue pour ses rendez-vous calmes, sa préparation soignée et ses finitions naturelles pour les clientes régulières du centre de Casablanca.", ar: "تُعرف ياسمينة بمواعيد هادئة، تحضير دقيق، ولمسات طبيعية للعميلات المنتظمات في وسط الدار البيضاء.")
        case "imanes": return text(language, fr: "Imane travaille un style léger et soigné pour dîners, soirées henné et brushings simples à domicile.", ar: "تقدم إيمان أسلوبًا خفيفًا ومرتبًا للعشاء، ليالي الحناء، والبراشينغ المنزلي.")
        case "soukaina": return text(language, fr: "Soukaina se concentre sur le maquillage d’occasion et les cils avec un fini net, élégant et photogénique.", ar: "تركز سكينة على مكياج المناسبات والرموش بلمسة نظيفة وأنيقة وجاهزة للصور.")
        case "najat": return text(language, fr: "Najat est un choix régulier pour l’entretien beauté hebdomadaire, surtout brushing et manucure classique.", ar: "نجاة خيار ثابت للعناية الأسبوعية، خصوصًا البراشينغ والمانيكير الكلاسيكي.")
        case "fatima": return text(language, fr: "Fatima Zahra est souvent réservée pour les sourcils nets, la teinture des cils et les soins naturels des ongles.", ar: "تُحجز فاطمة الزهراء كثيرًا للحواجب المرتبة، صبغ الرموش، والعناية الطبيعية بالأظافر.")
        case "hiba": return text(language, fr: "Hiba apporte un œil moderne aux rendez-vous beauté simples, avec une installation calme et un kit propre.", ar: "تجلب هبة ذوقًا عصريًا للمواعيد البسيطة مع تحضير هادئ وعدة نظيفة.")
        case "asmae": return text(language, fr: "Asmae garde les rendez-vous simples et précis, avec un focus sur les ongles courts et les couleurs subtiles.", ar: "تحافظ أسماء على مواعيد بسيطة ودقيقة، مع تركيز على الأظافر القصيرة والألوان الناعمة.")
        case "malika": return text(language, fr: "Malika se spécialise dans les brushings lisses et les coiffures rapides pour clientes près de Gauthier et Anfa.", ar: "تتخصص مليكة في البراشينغ الناعم وتسريحات المناسبات السريعة قرب غوتيي وأنفا.")
        default: return provider.bio
        }
    }

    static func serviceName(_ id: String, fallback: String, language: KhedmaLanguage) -> String {
        let value = id.lowercased()
        if value.contains("pedi") { return text(language, fr: "Pédicure douce", ar: "باديكير ناعم") }
        if value.contains("brow") { return text(language, fr: "Sourcils nets", ar: "تنظيف الحواجب") }
        if value.contains("brushing") { return text(language, fr: "Brushing à domicile", ar: "براشينغ منزلي") }
        if value.contains("soft-glam") { return text(language, fr: "Maquillage doux", ar: "مكياج ناعم") }
        if value.contains("hair-makeup") { return text(language, fr: "Coiffure + maquillage", ar: "شعر ومكياج") }
        if value.contains("event") || value.contains("occasion") { return text(language, fr: "Mise en beauté occasion", ar: "مكياج مناسبة") }
        if value.contains("lash") { return text(language, fr: "Rehaussement des cils", ar: "رفع الرموش") }
        if value.contains("touchup") { return text(language, fr: "Retouche maquillage", ar: "تجديد المكياج") }
        if value.contains("classic") { return text(language, fr: "Manucure classique", ar: "مانيكير كلاسيكي") }
        if value.contains("waves") { return text(language, fr: "Ondulations souples", ar: "تمويج ناعم") }
        if value.contains("natural") { return text(language, fr: "Beauté naturelle", ar: "لمسة طبيعية") }
        if value.contains("photo") { return text(language, fr: "Pack prêt photo", ar: "باقة جاهزة للتصوير") }
        if value.contains("minimal") { return text(language, fr: "Gel minimal", ar: "جل بسيط") }
        if value.contains("removal") { return text(language, fr: "Retrait gel + soin", ar: "إزالة الجل مع عناية") }
        if value.contains("chignon") { return text(language, fr: "Chignon souple", ar: "شينيون ناعم") }
        if value.contains("gel") { return text(language, fr: "Manucure gel", ar: "مانيكير جل") }
        return text(language, fr: "Service beauté", ar: "خدمة جمال")
    }

    static func providerTags(_ provider: Provider, language: KhedmaLanguage) -> [String] {
        provider.serviceTags.map { tag in
            switch tag {
            case "Gel nails": return text(language, fr: "Gel", ar: "جل")
            case "Brow shaping", "Brows": return text(language, fr: "Sourcils", ar: "حواجب")
            case "French set": return text(language, fr: "French manucure", ar: "فرنش")
            case "Brushing": return text(language, fr: "Brushing", ar: "براشينغ")
            case "Soft glam", "Natural glam": return text(language, fr: "Glam doux", ar: "مكياج ناعم")
            case "Event prep", "Event hair": return text(language, fr: "Événements", ar: "مناسبات")
            case "Luxury makeup": return text(language, fr: "Maquillage premium", ar: "مكياج راق")
            case "Lashes", "Lash tint": return text(language, fr: "Cils", ar: "رموش")
            case "Bride guest": return text(language, fr: "Invitée mariage", ar: "ضيفة عرس")
            case "Classic mani": return text(language, fr: "Manucure", ar: "مانيكير")
            case "Weekly care": return text(language, fr: "Soin régulier", ar: "عناية دورية")
            case "Natural nails": return text(language, fr: "Ongles naturels", ar: "أظافر طبيعية")
            case "Hair waves": return text(language, fr: "Ondulations", ar: "تمويج")
            case "Photos": return text(language, fr: "Photos", ar: "صور")
            case "Short nails": return text(language, fr: "Ongles courts", ar: "أظافر قصيرة")
            case "Gel removal": return text(language, fr: "Retrait gel", ar: "إزالة الجل")
            case "Minimal sets": return text(language, fr: "Style minimal", ar: "ستايل بسيط")
            case "Chignon": return text(language, fr: "Chignon", ar: "شينيون")
            default: return tag
            }
        }
    }

    static func availabilityLabel(_ label: String, language: KhedmaLanguage) -> String {
        switch label {
        case "Today": return text(language, fr: "Aujourd’hui", ar: "اليوم")
        case "Tomorrow": return text(language, fr: "Demain", ar: "غدًا")
        case "Thursday": return text(language, fr: "Jeudi", ar: "الخميس")
        case "Friday": return text(language, fr: "Vendredi", ar: "الجمعة")
        case "Saturday": return text(language, fr: "Samedi", ar: "السبت")
        case "Sunday": return text(language, fr: "Dimanche", ar: "الأحد")
        default: return label
        }
    }

    static func bookingService(_ booking: Booking, language: KhedmaLanguage) -> String {
        serviceName(booking.serviceName, fallback: booking.serviceName, language: language)
    }

    static func bookingDate(_ label: String, language: KhedmaLanguage) -> String {
        switch label {
        case "Today": return availabilityLabel(label, language: language)
        case "Mar 18": return text(language, fr: "18 mars", ar: "18 مارس")
        case "Feb 28": return text(language, fr: "28 février", ar: "28 فبراير")
        case "Mar 2": return text(language, fr: "2 mars", ar: "2 مارس")
        default: return label
        }
    }

    static func bookingAddress(_ address: String, language: KhedmaLanguage) -> String {
        guard language == .arabic else {
            return address
                .replacingOccurrences(of: "Twin Center area", with: "près du Twin Center")
                .replacingOccurrences(of: "near Massira", with: "près de Massira")
                .replacingOccurrences(of: "Racine side", with: "côté Racine")
                .replacingOccurrences(of: "near Lycee Lyautey", with: "près du Lycée Lyautey")
        }
        if address.contains("Maarif") { return "المعاريف، قرب توين سنتر" }
        if address.contains("Gauthier") { return "غوتيي، قرب شارع المسيرة" }
        if address.contains("Bourgogne") { return "بوركون، جهة راسين" }
        if address.contains("CIL") { return "سي آي إل، قرب ليسيه ليوطي" }
        if address.contains("Anfa") { return "أنفا، شارع أنفا" }
        return address
    }

    static func bookingNote(_ note: String, language: KhedmaLanguage) -> String {
        switch note {
        case "Please bring soft pink options.": return text(language, fr: "Merci d’apporter des tons rose doux.", ar: "المرجو إحضار درجات وردية ناعمة.")
        case "Natural finish.": return text(language, fr: "Fini naturel.", ar: "لمسة طبيعية.")
        case "Client rescheduled.": return text(language, fr: "La cliente a déplacé le rendez-vous.", ar: "تم تغيير الموعد من طرف العميلة.")
        default: return note
        }
    }

    static func trustTitle(_ badge: TrustBadge, language: KhedmaLanguage) -> String {
        switch badge.id {
        case "id": return text(language, fr: "Identité vérifiée", ar: "الهوية موثقة")
        case "interview": return text(language, fr: "Entretien équipe", ar: "مقابلة مع الفريق")
        case "portfolio": return text(language, fr: "Portfolio validé", ar: "أعمال موثقة")
        default: return badge.title
        }
    }

    static func trustSubtitle(_ badge: TrustBadge, language: KhedmaLanguage) -> String {
        switch badge.id {
        case "id": return text(language, fr: "Documents vérifiés par l’équipe", ar: "وثائق تمت مراجعتها من الفريق")
        case "interview": return text(language, fr: "Qualité et conduite évaluées", ar: "تم تقييم الجودة والسلوك")
        case "portfolio": return text(language, fr: "Exemples de travail approuvés", ar: "نماذج العمل تمت الموافقة عليها")
        default: return badge.subtitle
        }
    }

    static func reviewText(_ review: Review, language: KhedmaLanguage) -> String {
        switch review.id {
        case "r1": return text(language, fr: "Très précise et gentille. Le rendez-vous était organisé du début à la fin.", ar: "دقيقة ولطيفة جدًا. كان الموعد منظمًا من البداية للنهاية.")
        case "r2": return text(language, fr: "Joli gel, et elle est arrivée avec tout le nécessaire.", ar: "جل جميل ووصلت بكل ما يلزم.")
        case "r3": return text(language, fr: "Maquillage élégant, pas chargé. Exactement ce que je voulais.", ar: "مكياج أنيق وغير ثقيل. بالضبط ما أردته.")
        case "r4": return text(language, fr: "Kit professionnel et attitude très respectueuse à la maison.", ar: "عدة احترافية وتعامل محترم جدًا داخل المنزل.")
        default: return text(language, fr: "Expérience soignée et ponctuelle.", ar: "تجربة مرتبة وفي الموعد.")
        }
    }

    static func reviewAuthor(_ review: Review, language: KhedmaLanguage) -> String {
        guard language == .arabic else { return review.author }
        switch review.id {
        case "r1": return "سلمى ب."
        case "r2": return "نورا أ."
        case "r3": return "مريم ل."
        case "r4": return "هدى ر."
        case "r5": return "لينا م."
        case "r6": return "غيثة س."
        case "r7": return "آية إ."
        case "r8": return "ريم ت."
        case "r9": return "دينا ك."
        case "r10": return "صوفيا س."
        case "r11": return "إيناس ج."
        case "r12": return "ليلى هـ."
        case "r13": return "منى ز."
        case "r14": return "جيهان و."
        case "r15": return "سارة ن."
        case "r16": return "أمل ف."
        default: return review.author
        }
    }

    static func customerName(_ name: String, language: KhedmaLanguage) -> String {
        guard language == .arabic else { return name }
        switch name {
        case "Lina Bennis": return "لينا بنيس"
        default: return name
        }
    }

    static func reviewDate(_ date: String, language: KhedmaLanguage) -> String {
        switch date {
        case "Mar 2026": return text(language, fr: "mars 2026", ar: "مارس 2026")
        case "Feb 2026": return text(language, fr: "février 2026", ar: "فبراير 2026")
        case "Jan 2026": return text(language, fr: "janvier 2026", ar: "يناير 2026")
        default: return date
        }
    }

    static func duration(_ duration: String, language: KhedmaLanguage) -> String {
        switch duration {
        case "2 hr": return text(language, fr: "2 h", ar: "ساعتان")
        default:
            if duration.contains("min") {
                return language == .arabic ? duration.replacingOccurrences(of: "min", with: "د") : duration
            }
            return duration
        }
    }

    static func responseTime(_ responseTime: String, language: KhedmaLanguage) -> String {
        guard language == .arabic else { return responseTime }
        return responseTime
            .replacingOccurrences(of: "min", with: "د")
            .replacingOccurrences(of: "hr", with: "س")
    }

    static func coverageETA(_ eta: String, language: KhedmaLanguage) -> String {
        guard language == .arabic else { return eta }
        return eta.replacingOccurrences(of: "h", with: "س")
    }

    static func portfolioTitle(_ item: PortfolioWork, language: KhedmaLanguage) -> String {
        switch item.symbol {
        case "comb.fill": return specialty(.hair, language: language)
        case "eye.fill": return specialty(.browsLashes, language: language)
        case "paintbrush.pointed.fill": return specialty(.makeup, language: language)
        default: return specialty(.nails, language: language)
        }
    }

    static func portfolioSubtitle(_ item: PortfolioWork, language: KhedmaLanguage) -> String {
        text(language, fr: "Travail validé", ar: "عمل موثق")
    }

    static func onboardingStepTitle(_ step: OnboardingStep, language: KhedmaLanguage) -> String {
        switch step.id {
        case "id": return text(language, fr: "Pièce d’identité", ar: "بطاقة الهوية")
        case "selfie": return text(language, fr: "Vérification selfie", ar: "تحقق بالصورة")
        case "services": return text(language, fr: "Choix des services", ar: "اختيار الخدمات")
        case "city": return text(language, fr: "Ville et quartier", ar: "المدينة والحي")
        case "experience": return text(language, fr: "Années d’expérience", ar: "سنوات الخبرة")
        case "portfolio": return text(language, fr: "Photos portfolio", ar: "صور الأعمال")
        case "certs": return text(language, fr: "Certifications", ar: "الشهادات")
        case "availability": return text(language, fr: "Disponibilités", ar: "المواعيد")
        case "submit": return text(language, fr: "Envoi pour revue", ar: "الإرسال للمراجعة")
        default: return step.title
        }
    }

    static func onboardingStepDetail(_ step: OnboardingStep, language: KhedmaLanguage) -> String {
        switch step.id {
        case "id": return text(language, fr: "Nous vérifions chaque candidature avant les réservations clientes.", ar: "نراجع كل طلب قبل فتح حجوزات العميلات.")
        case "selfie": return text(language, fr: "Une correspondance rapide renforce la confiance.", ar: "مطابقة سريعة تعزز الثقة.")
        case "services": return text(language, fr: "Sélectionnez les services que vous pouvez réaliser à domicile.", ar: "اختاري الخدمات التي يمكنك تقديمها في المنزل.")
        case "city": return text(language, fr: "Commencez par les zones de Casablanca que vous connaissez.", ar: "ابدئي بمناطق الدار البيضاء التي تعرفينها.")
        case "experience": return text(language, fr: "Aidez l’équipe à comprendre votre niveau.", ar: "ساعدي الفريق على فهم مستوى خبرتك.")
        case "portfolio": return text(language, fr: "Ajoutez quelques exemples clairs pour revue.", ar: "أضيفي أمثلة واضحة للمراجعة.")
        case "certs": return text(language, fr: "Ajoutez des documents si la catégorie le demande.", ar: "أضيفي الوثائق إذا كانت الفئة تتطلب ذلك.")
        case "availability": return text(language, fr: "Partagez les jours et heures possibles.", ar: "حددي الأيام والأوقات المناسبة.")
        case "submit": return text(language, fr: "Une coordinatrice vérifie qualité, conduite et cohérence.", ar: "تراجع المنسقة الجودة، السلوك، ومدى الملاءمة.")
        default: return step.detail
        }
    }

    static func serviceImageAsset(for specialty: BeautySpecialty) -> String {
        switch specialty {
        case .nails: "ServiceNails"
        case .hair: "ServiceHair"
        case .makeup, .browsLashes: "ServiceMakeup"
        }
    }

    static func providerImageAsset(_ provider: Provider) -> String {
        switch provider.id {
        case "yasmina": "ProviderYasmina"
        case "imanes": "ProviderImane"
        case "soukaina": "ProviderSoukaina"
        case "najat": "ProviderNajat"
        case "fatima": "ProviderFatima"
        case "hiba": "ProviderHiba"
        case "asmae": "ProviderAsmae"
        case "malika": "ProviderMalika"
        default: "ProviderYasmina"
        }
    }

    static func portfolioImageAsset(_ item: PortfolioWork) -> String {
        switch item.symbol {
        case "comb.fill", "camera.aperture":
            "ServiceHair"
        case "paintbrush.pointed.fill", "camera.fill", "eye.fill":
            "ServiceMakeup"
        default:
            "ServiceNails"
        }
    }

    static func chatText(_ message: ChatMessage, language: KhedmaLanguage) -> String {
        language == .arabic ? message.textAR : message.textFR
    }
}

extension KhedmaLanguage {
    func copy(fr: String, ar: String) -> String {
        KhedmaCopy.text(self, fr: fr, ar: ar)
    }
}
