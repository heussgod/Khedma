import Foundation

enum MockData {
    static let departments: [Department] = [
        Department(id: "beauty", title: "Beauty at Home", subtitle: "Live in Casablanca", symbol: "sparkles", status: .active),
        Department(id: "helpers", title: "Helper Tasks", subtitle: "Coming Soon", symbol: "hands.sparkles.fill", status: .comingSoon),
        Department(id: "trades", title: "Skilled Trades", subtitle: "Coming Soon", symbol: "wrench.and.screwdriver.fill", status: .comingSoon),
        Department(id: "transport", title: "Women-only rides", subtitle: "Coming Soon", symbol: "car.fill", status: .comingSoon)
    ]

    static let beautyCategories: [BeautyCategory] = [
        BeautyCategory(id: "nails", name: "Nails", symbol: "sparkles", specialty: .nails),
        BeautyCategory(id: "hair", name: "Hair Styling", symbol: "comb.fill", specialty: .hair),
        BeautyCategory(id: "makeup", name: "Makeup", symbol: "paintbrush.pointed.fill", specialty: .makeup),
        BeautyCategory(id: "brows", name: "Brows & Lashes", symbol: "eye.fill", specialty: .browsLashes)
    ]

    static let customerInterestOptions: [SelectableOption] = [
        SelectableOption(id: "beauty", title: "Beauty at Home", subtitle: "Nails, hair, makeup, brows", symbol: "sparkles", palette: .rose),
        SelectableOption(id: "helpers", title: "Helper Tasks", subtitle: "Reliable home help, soon", symbol: "hands.sparkles.fill", palette: .olive),
        SelectableOption(id: "trades", title: "Skilled Trades", subtitle: "Plumbers, electricians, vetted repairs", symbol: "wrench.and.screwdriver.fill", palette: .ocean)
    ]

    static let workerCategoryOptions: [SelectableOption] = [
        SelectableOption(id: "nails", title: "Nails", subtitle: "Manicure, gel, pedicure", symbol: "sparkles", palette: .rose),
        SelectableOption(id: "hair", title: "Hair", subtitle: "Brushing, waves, chignon", symbol: "comb.fill", palette: .clay),
        SelectableOption(id: "makeup", title: "Makeup", subtitle: "Soft glam and events", symbol: "paintbrush.pointed.fill", palette: .ink),
        SelectableOption(id: "cleaning", title: "Cleaning", subtitle: "Future home care line", symbol: "bubbles.and.sparkles.fill", palette: .olive),
        SelectableOption(id: "helpers", title: "Helper Tasks", subtitle: "Errands and home support", symbol: "hands.sparkles.fill", palette: .sand),
        SelectableOption(id: "plumbing", title: "Plumbing", subtitle: "Repairs and installs", symbol: "pipe.and.drop.fill", palette: .ocean),
        SelectableOption(id: "woodwork", title: "Woodwork", subtitle: "Small carpentry jobs", symbol: "hammer.fill", palette: .gold),
        SelectableOption(id: "zellige", title: "Zellige / Tile", subtitle: "Tile and finishing work", symbol: "square.grid.3x3.fill", palette: .clay),
        SelectableOption(id: "electrical", title: "Electrical", subtitle: "Licensed work only", symbol: "bolt.fill", palette: .ink)
    ]

    static let cities = ["Casablanca", "Rabat", "Marrakech"]

    static let neighborhoodsByCity: [String: [String]] = [
        "Casablanca": ["Maarif", "Gauthier", "Californie", "Anfa", "Bourgogne", "CIL"],
        "Rabat": ["Agdal", "Hay Riad", "Souissi", "Hassan"],
        "Marrakech": ["Gueliz", "Hivernage", "Majorelle", "Targa"]
    ]

    static let trustBadges: [TrustBadge] = [
        TrustBadge(id: "id", title: "ID verified", subtitle: "Documents checked by Khedma", symbol: "checkmark.seal.fill"),
        TrustBadge(id: "interview", title: "Interviewed by team", subtitle: "Quality and conduct screen", symbol: "person.text.rectangle.fill"),
        TrustBadge(id: "portfolio", title: "Portfolio reviewed", subtitle: "Work samples approved", symbol: "photo.stack.fill")
    ]

    static let providers: [Provider] = [
        Provider(
            id: "yasmina",
            name: "Yasmina El Amrani",
            initials: "YA",
            neighborhood: "Gauthier",
            specialties: [.nails, .browsLashes],
            rating: 4.96,
            completedJobs: 318,
            responseTime: "8 min",
            punctualityScore: 98,
            startingPrice: 180,
            bio: "Yasmina is known for calm appointments, careful prep, and clean natural finishes for regular clients in central Casablanca.",
            serviceTags: ["Gel nails", "Brow shaping", "French set"],
            badges: [.topRated, .repeatFavorite],
            services: [
                ServiceItem(id: "yasmina-gel", name: "Gel manicure", specialty: .nails, duration: "75 min", startingPrice: 180),
                ServiceItem(id: "yasmina-pedi", name: "Soft pedicure", specialty: .nails, duration: "80 min", startingPrice: 220),
                ServiceItem(id: "yasmina-brow", name: "Brow shaping", specialty: .browsLashes, duration: "35 min", startingPrice: 120)
            ],
            availability: [
                AvailabilitySlot(id: "yasmina-today-17", label: "Today", time: "17:30"),
                AvailabilitySlot(id: "yasmina-tomorrow-10", label: "Tomorrow", time: "10:00"),
                AvailabilitySlot(id: "yasmina-sat-12", label: "Saturday", time: "12:30")
            ],
            reviews: [
                Review(id: "r1", author: "Salma B.", rating: 5.0, date: "Mar 2026", text: "Very precise and kind. The appointment felt organized from start to finish."),
                Review(id: "r2", author: "Nora A.", rating: 4.9, date: "Feb 2026", text: "Beautiful gel set and she arrived with everything ready.")
            ],
            portfolio: [
                PortfolioWork(id: "p1", title: "Soft pink gel", subtitle: "Before / after", symbol: "sparkles", palette: .rose),
                PortfolioWork(id: "p2", title: "Clean French", subtitle: "Repeat client", symbol: "hand.raised.fill", palette: .clay),
                PortfolioWork(id: "p3", title: "Natural brows", subtitle: "Shape refresh", symbol: "eye.fill", palette: .olive)
            ],
            trustBadges: trustBadges,
            avatarPalette: .rose
        ),
        Provider(
            id: "imanes",
            name: "Imane Saidi",
            initials: "IS",
            neighborhood: "Maarif",
            specialties: [.hair, .makeup],
            rating: 4.91,
            completedJobs: 241,
            responseTime: "12 min",
            punctualityScore: 96,
            startingPrice: 250,
            bio: "Imane works with a light, polished style for dinners, henna nights, and simple at-home blowouts.",
            serviceTags: ["Brushing", "Soft glam", "Event prep"],
            badges: [.repeatFavorite],
            services: [
                ServiceItem(id: "imane-brushing", name: "Brushing at home", specialty: .hair, duration: "60 min", startingPrice: 250),
                ServiceItem(id: "imane-soft-glam", name: "Soft glam makeup", specialty: .makeup, duration: "90 min", startingPrice: 420),
                ServiceItem(id: "imane-hair-makeup", name: "Hair + makeup", specialty: .makeup, duration: "2 hr", startingPrice: 620)
            ],
            availability: [
                AvailabilitySlot(id: "imane-today-19", label: "Today", time: "19:00"),
                AvailabilitySlot(id: "imane-thu-11", label: "Thursday", time: "11:30"),
                AvailabilitySlot(id: "imane-fri-16", label: "Friday", time: "16:00")
            ],
            reviews: [
                Review(id: "r3", author: "Meriem L.", rating: 5.0, date: "Mar 2026", text: "Elegant makeup, not heavy. Exactly what I wanted."),
                Review(id: "r4", author: "Houda R.", rating: 4.8, date: "Jan 2026", text: "Professional kit and very respectful at home.")
            ],
            portfolio: [
                PortfolioWork(id: "p4", title: "Soft glam", subtitle: "Dinner look", symbol: "paintbrush.pointed.fill", palette: .clay),
                PortfolioWork(id: "p5", title: "Smooth brushing", subtitle: "Medium hair", symbol: "comb.fill", palette: .ink),
                PortfolioWork(id: "p6", title: "Warm evening eye", subtitle: "Before / after", symbol: "eye.fill", palette: .rose)
            ],
            trustBadges: trustBadges,
            avatarPalette: .clay
        ),
        Provider(
            id: "soukaina",
            name: "Soukaina Bennani",
            initials: "SB",
            neighborhood: "Anfa",
            specialties: [.makeup, .browsLashes],
            rating: 4.98,
            completedJobs: 402,
            responseTime: "6 min",
            punctualityScore: 99,
            startingPrice: 300,
            bio: "Soukaina focuses on elevated occasion makeup and lashes with a clean, camera-ready finish.",
            serviceTags: ["Luxury makeup", "Lashes", "Bride guest"],
            badges: [.topRated, .fastResponse],
            services: [
                ServiceItem(id: "soukaina-event", name: "Occasion makeup", specialty: .makeup, duration: "95 min", startingPrice: 520),
                ServiceItem(id: "soukaina-lashes", name: "Lash lift", specialty: .browsLashes, duration: "60 min", startingPrice: 300),
                ServiceItem(id: "soukaina-touchup", name: "Makeup refresh", specialty: .makeup, duration: "45 min", startingPrice: 300)
            ],
            availability: [
                AvailabilitySlot(id: "soukaina-tomorrow-14", label: "Tomorrow", time: "14:00"),
                AvailabilitySlot(id: "soukaina-fri-18", label: "Friday", time: "18:30"),
                AvailabilitySlot(id: "soukaina-sun-11", label: "Sunday", time: "11:00")
            ],
            reviews: [
                Review(id: "r5", author: "Lina M.", rating: 5.0, date: "Mar 2026", text: "She understood the brief immediately. Very premium feeling."),
                Review(id: "r6", author: "Ghita S.", rating: 5.0, date: "Feb 2026", text: "The Khedma team confirmed everything on WhatsApp. Smooth experience.")
            ],
            portfolio: [
                PortfolioWork(id: "p7", title: "Occasion look", subtitle: "Soft contour", symbol: "camera.aperture", palette: .ink),
                PortfolioWork(id: "p8", title: "Lash lift", subtitle: "Natural curve", symbol: "eye.fill", palette: .olive),
                PortfolioWork(id: "p9", title: "Guest makeup", subtitle: "Warm finish", symbol: "sparkles", palette: .clay)
            ],
            trustBadges: trustBadges,
            avatarPalette: .ink
        ),
        Provider(
            id: "najat",
            name: "Najat El Fassi",
            initials: "NF",
            neighborhood: "Californie",
            specialties: [.hair, .nails],
            rating: 4.88,
            completedJobs: 176,
            responseTime: "18 min",
            punctualityScore: 94,
            startingPrice: 190,
            bio: "Najat is a steady choice for weekly beauty maintenance, especially brushing and classic manicures.",
            serviceTags: ["Classic mani", "Brushing", "Weekly care"],
            badges: [],
            services: [
                ServiceItem(id: "najat-classic", name: "Classic manicure", specialty: .nails, duration: "60 min", startingPrice: 190),
                ServiceItem(id: "najat-brushing", name: "Weekly brushing", specialty: .hair, duration: "55 min", startingPrice: 240),
                ServiceItem(id: "najat-combo", name: "Hair + nails refresh", specialty: .hair, duration: "2 hr", startingPrice: 390)
            ],
            availability: [
                AvailabilitySlot(id: "najat-today-15", label: "Today", time: "15:00"),
                AvailabilitySlot(id: "najat-thu-10", label: "Thursday", time: "10:30"),
                AvailabilitySlot(id: "najat-sat-17", label: "Saturday", time: "17:00")
            ],
            reviews: [
                Review(id: "r7", author: "Aya E.", rating: 4.8, date: "Feb 2026", text: "Reliable and very tidy."),
                Review(id: "r8", author: "Rim T.", rating: 4.9, date: "Jan 2026", text: "Perfect for a simple weekly appointment.")
            ],
            portfolio: [
                PortfolioWork(id: "p10", title: "Classic red", subtitle: "Manicure", symbol: "sparkles", palette: .rose),
                PortfolioWork(id: "p11", title: "Clean brushing", subtitle: "Weekly care", symbol: "comb.fill", palette: .olive),
                PortfolioWork(id: "p12", title: "Short nails", subtitle: "Natural polish", symbol: "hand.raised.fill", palette: .clay)
            ],
            trustBadges: trustBadges,
            avatarPalette: .olive
        ),
        Provider(
            id: "fatima",
            name: "Fatima Zahra Kadiri",
            initials: "FK",
            neighborhood: "Bourgogne",
            specialties: [.browsLashes, .nails],
            rating: 4.93,
            completedJobs: 227,
            responseTime: "10 min",
            punctualityScore: 97,
            startingPrice: 140,
            bio: "Fatima Zahra is booked often for neat brows, lash tinting, and natural-looking nail care.",
            serviceTags: ["Brows", "Lash tint", "Natural nails"],
            badges: [.repeatFavorite],
            services: [
                ServiceItem(id: "fatima-brows", name: "Brow shape + tint", specialty: .browsLashes, duration: "45 min", startingPrice: 140),
                ServiceItem(id: "fatima-lash", name: "Lash tint", specialty: .browsLashes, duration: "35 min", startingPrice: 150),
                ServiceItem(id: "fatima-natural", name: "Natural manicure", specialty: .nails, duration: "55 min", startingPrice: 170)
            ],
            availability: [
                AvailabilitySlot(id: "fatima-tomorrow-9", label: "Tomorrow", time: "09:30"),
                AvailabilitySlot(id: "fatima-fri-13", label: "Friday", time: "13:00"),
                AvailabilitySlot(id: "fatima-sun-16", label: "Sunday", time: "16:30")
            ],
            reviews: [
                Review(id: "r9", author: "Dina K.", rating: 4.9, date: "Mar 2026", text: "Gentle and precise. My brows looked natural."),
                Review(id: "r10", author: "Sofia C.", rating: 5.0, date: "Feb 2026", text: "I rebooked immediately.")
            ],
            portfolio: [
                PortfolioWork(id: "p13", title: "Brow reset", subtitle: "Shape + tint", symbol: "eye.fill", palette: .ink),
                PortfolioWork(id: "p14", title: "Lash tint", subtitle: "Natural finish", symbol: "sparkles", palette: .rose),
                PortfolioWork(id: "p15", title: "Clean manicure", subtitle: "Soft shine", symbol: "hand.raised.fill", palette: .olive)
            ],
            trustBadges: trustBadges,
            avatarPalette: .rose
        ),
        Provider(
            id: "hiba",
            name: "Hiba Alaoui",
            initials: "HA",
            neighborhood: "CIL",
            specialties: [.makeup, .hair],
            rating: 4.86,
            completedJobs: 132,
            responseTime: "16 min",
            punctualityScore: 95,
            startingPrice: 280,
            bio: "Hiba brings an editorial eye to simple beauty moments, with a calm setup and clean product kit.",
            serviceTags: ["Hair waves", "Natural glam", "Photos"],
            badges: [.fastResponse],
            services: [
                ServiceItem(id: "hiba-waves", name: "Soft waves", specialty: .hair, duration: "70 min", startingPrice: 280),
                ServiceItem(id: "hiba-natural", name: "Natural glam", specialty: .makeup, duration: "80 min", startingPrice: 380),
                ServiceItem(id: "hiba-photo", name: "Photo-ready package", specialty: .makeup, duration: "2 hr", startingPrice: 650)
            ],
            availability: [
                AvailabilitySlot(id: "hiba-today-20", label: "Today", time: "20:00"),
                AvailabilitySlot(id: "hiba-thu-15", label: "Thursday", time: "15:00"),
                AvailabilitySlot(id: "hiba-sat-10", label: "Saturday", time: "10:00")
            ],
            reviews: [
                Review(id: "r11", author: "Ines J.", rating: 4.8, date: "Mar 2026", text: "Beautiful waves that lasted all evening."),
                Review(id: "r12", author: "Leila H.", rating: 4.9, date: "Jan 2026", text: "Friendly, punctual, and very prepared.")
            ],
            portfolio: [
                PortfolioWork(id: "p16", title: "Soft waves", subtitle: "Long hair", symbol: "comb.fill", palette: .clay),
                PortfolioWork(id: "p17", title: "Natural glam", subtitle: "Day event", symbol: "paintbrush.pointed.fill", palette: .rose),
                PortfolioWork(id: "p18", title: "Photo look", subtitle: "Clean glow", symbol: "camera.fill", palette: .ink)
            ],
            trustBadges: trustBadges,
            avatarPalette: .clay
        ),
        Provider(
            id: "asmae",
            name: "Asmae Lahlou",
            initials: "AL",
            neighborhood: "Maarif",
            specialties: [.nails],
            rating: 4.9,
            completedJobs: 205,
            responseTime: "14 min",
            punctualityScore: 96,
            startingPrice: 160,
            bio: "Asmae keeps appointments simple and precise, with a focus on short nails and subtle color.",
            serviceTags: ["Short nails", "Gel removal", "Minimal sets"],
            badges: [.topRated],
            services: [
                ServiceItem(id: "asmae-minimal", name: "Minimal gel set", specialty: .nails, duration: "70 min", startingPrice: 210),
                ServiceItem(id: "asmae-removal", name: "Gel removal + care", specialty: .nails, duration: "45 min", startingPrice: 160),
                ServiceItem(id: "asmae-classic", name: "Classic polish", specialty: .nails, duration: "55 min", startingPrice: 180)
            ],
            availability: [
                AvailabilitySlot(id: "asmae-tomorrow-12", label: "Tomorrow", time: "12:00"),
                AvailabilitySlot(id: "asmae-fri-10", label: "Friday", time: "10:30"),
                AvailabilitySlot(id: "asmae-sun-18", label: "Sunday", time: "18:00")
            ],
            reviews: [
                Review(id: "r13", author: "Mouna Z.", rating: 4.9, date: "Feb 2026", text: "Minimal and neat, exactly my style."),
                Review(id: "r14", author: "Jihane O.", rating: 4.9, date: "Jan 2026", text: "She took real care with removal.")
            ],
            portfolio: [
                PortfolioWork(id: "p19", title: "Milky gel", subtitle: "Minimal set", symbol: "sparkles", palette: .rose),
                PortfolioWork(id: "p20", title: "Care reset", subtitle: "After removal", symbol: "hand.raised.fill", palette: .olive),
                PortfolioWork(id: "p21", title: "Soft color", subtitle: "Short nails", symbol: "circle.fill", palette: .clay)
            ],
            trustBadges: trustBadges,
            avatarPalette: .olive
        ),
        Provider(
            id: "malika",
            name: "Malika Rami",
            initials: "MR",
            neighborhood: "Gauthier",
            specialties: [.hair],
            rating: 4.84,
            completedJobs: 119,
            responseTime: "20 min",
            punctualityScore: 93,
            startingPrice: 230,
            bio: "Malika specializes in smooth brushing and quick event-ready hair for clients near Gauthier and Anfa.",
            serviceTags: ["Brushing", "Chignon", "Event hair"],
            badges: [],
            services: [
                ServiceItem(id: "malika-brushing", name: "Smooth brushing", specialty: .hair, duration: "60 min", startingPrice: 230),
                ServiceItem(id: "malika-chignon", name: "Soft chignon", specialty: .hair, duration: "85 min", startingPrice: 360),
                ServiceItem(id: "malika-event", name: "Event hair finish", specialty: .hair, duration: "75 min", startingPrice: 320)
            ],
            availability: [
                AvailabilitySlot(id: "malika-today-18", label: "Today", time: "18:00"),
                AvailabilitySlot(id: "malika-thu-17", label: "Thursday", time: "17:30"),
                AvailabilitySlot(id: "malika-sat-14", label: "Saturday", time: "14:00")
            ],
            reviews: [
                Review(id: "r15", author: "Sara N.", rating: 4.8, date: "Mar 2026", text: "Fast and polished."),
                Review(id: "r16", author: "Amal F.", rating: 4.9, date: "Feb 2026", text: "Loved the chignon for a family dinner.")
            ],
            portfolio: [
                PortfolioWork(id: "p22", title: "Soft chignon", subtitle: "Evening", symbol: "camera.aperture", palette: .ink),
                PortfolioWork(id: "p23", title: "Smooth brushing", subtitle: "Medium hair", symbol: "comb.fill", palette: .clay),
                PortfolioWork(id: "p24", title: "Event finish", subtitle: "Held all night", symbol: "sparkles", palette: .rose)
            ],
            trustBadges: trustBadges,
            avatarPalette: .ink
        )
    ]

    static let bookings: [Booking] = [
        Booking(id: "book-1", providerID: "yasmina", serviceName: "Gel manicure", dateLabel: "Today", timeLabel: "17:30", address: "Maarif, Twin Center area", price: 180, status: .upcoming, paymentMethod: .cash, note: "Please bring soft pink options."),
        Booking(id: "book-2", providerID: "imanes", serviceName: "Soft glam makeup", dateLabel: "Mar 18", timeLabel: "19:00", address: "Gauthier, near Massira", price: 420, status: .past, paymentMethod: .cash, note: "Natural finish."),
        Booking(id: "book-3", providerID: "fatima", serviceName: "Brow shape + tint", dateLabel: "Feb 28", timeLabel: "11:00", address: "Bourgogne, Racine side", price: 140, status: .past, paymentMethod: .card, note: ""),
        Booking(id: "book-4", providerID: "hiba", serviceName: "Soft waves", dateLabel: "Mar 2", timeLabel: "18:00", address: "CIL, near Lycee Lyautey", price: 280, status: .cancelled, paymentMethod: .cash, note: "Client rescheduled.")
    ]

    static let profile = CustomerProfile(
        name: "Lina Bennis",
        phone: "+212 6 12 34 56 78",
        city: "Casablanca",
        savedAddresses: ["Maarif, Twin Center area", "Gauthier, near Massira", "Anfa, Boulevard d'Anfa"],
        paymentMethods: ["Espèces après service", "Visa se terminant par 0426"],
        supportHistory: ["Horaire manucure gel modifié", "Question de remboursement traitée"]
    )

    static let onboardingSteps: [OnboardingStep] = [
        OnboardingStep(id: "id", title: "Upload ID", detail: "We verify every applicant before clients can book.", symbol: "person.text.rectangle.fill"),
        OnboardingStep(id: "selfie", title: "Selfie verification", detail: "A quick identity match keeps the platform trusted.", symbol: "camera.fill"),
        OnboardingStep(id: "services", title: "Choose services", detail: "Select the beauty services you can deliver at home.", symbol: "sparkles"),
        OnboardingStep(id: "city", title: "City and neighborhood", detail: "Start with Casablanca zones you know well.", symbol: "mappin.and.ellipse"),
        OnboardingStep(id: "experience", title: "Years of experience", detail: "Help operators understand your service level.", symbol: "chart.bar.fill"),
        OnboardingStep(id: "portfolio", title: "Portfolio photos", detail: "Upload a few clear examples for review.", symbol: "photo.stack.fill"),
        OnboardingStep(id: "certs", title: "Certifications or licenses", detail: "Add documents when a service requires proof.", symbol: "doc.badge.gearshape.fill"),
        OnboardingStep(id: "availability", title: "Set availability", detail: "Share the days and times that work for you.", symbol: "calendar.badge.clock"),
        OnboardingStep(id: "submit", title: "Submit for review", detail: "A Khedma operator checks quality, conduct, and fit.", symbol: "paperplane.fill")
    ]

    static let coverageZones: [CoverageZone] = [
        CoverageZone(id: "maarif", neighborhood: "Maarif", providerCount: 5, activeServices: [.nails, .hair, .makeup], etaRange: "2-4 h", mapX: 0.48, mapY: 0.48, palette: .rose),
        CoverageZone(id: "gauthier", neighborhood: "Gauthier", providerCount: 4, activeServices: [.nails, .hair], etaRange: "3-5 h", mapX: 0.56, mapY: 0.38, palette: .clay),
        CoverageZone(id: "anfa", neighborhood: "Anfa", providerCount: 3, activeServices: [.makeup, .browsLashes], etaRange: "4-6 h", mapX: 0.38, mapY: 0.34, palette: .ink),
        CoverageZone(id: "bourgogne", neighborhood: "Bourgogne", providerCount: 2, activeServices: [.nails, .browsLashes], etaRange: "4-7 h", mapX: 0.30, mapY: 0.54, palette: .olive),
        CoverageZone(id: "cil", neighborhood: "CIL", providerCount: 2, activeServices: [.hair, .makeup], etaRange: "5-7 h", mapX: 0.67, mapY: 0.63, palette: .ocean),
        CoverageZone(id: "californie", neighborhood: "Californie", providerCount: 2, activeServices: [.hair, .nails], etaRange: "6-8 h", mapX: 0.76, mapY: 0.73, palette: .gold)
    ]

    static let chatMessages: [ChatMessage] = [
        ChatMessage(
            id: "operator-1",
            sender: .coordinator,
            providerID: nil,
            textFR: "Votre réservation est en suivi Khedma. Une coordinatrice peut intervenir si l’heure ou l’adresse change.",
            textAR: "حجزك تحت متابعة خدمة. يمكن للمنسقة التدخل إذا تغيّر الوقت أو العنوان.",
            time: "16:42"
        ),
        ChatMessage(
            id: "provider-1",
            sender: .provider,
            providerID: "yasmina",
            textFR: "Bonjour Lina, je prépare les tons rose doux. L’adresse près du Twin Center est bien confirmée ?",
            textAR: "مرحبًا لينا، سأحضّر الدرجات الوردية الناعمة. هل العنوان قرب توين سنتر مؤكد؟",
            time: "16:44"
        ),
        ChatMessage(
            id: "customer-1",
            sender: .customer,
            providerID: nil,
            textFR: "Oui, l’adresse est confirmée. Je préfère une finition naturelle.",
            textAR: "نعم، العنوان مؤكد. أفضل لمسة طبيعية.",
            time: "16:46"
        ),
        ChatMessage(
            id: "operator-2",
            sender: .coordinator,
            providerID: nil,
            textFR: "Parfait. Khedma reste disponible jusqu’à la fin du service.",
            textAR: "ممتاز. خدمة تبقى متاحة إلى نهاية الخدمة.",
            time: "16:47"
        )
    ]
}
