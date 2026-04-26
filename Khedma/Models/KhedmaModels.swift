import Foundation

enum KhedmaLanguage: String, CaseIterable, Identifiable, Hashable {
    case french = "fr"
    case arabic = "ar"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .french: "Français"
        case .arabic: "العربية"
        }
    }

    var headline: String {
        switch self {
        case .french: "Continuer en français"
        case .arabic: "المتابعة بالعربية"
        }
    }

    var isRTL: Bool { self == .arabic }
}

enum UserRole: String, CaseIterable, Identifiable, Hashable {
    case customer
    case worker

    var id: String { rawValue }

    var title: String {
        switch self {
        case .customer: "Cliente"
        case .worker: "Professionnelle"
        }
    }
}

enum ApplicationStatus: String, CaseIterable, Identifiable, Hashable {
    case underReview = "Under review"
    case verified = "Verified"
    case needMoreInfo = "Need more info"

    var id: String { rawValue }
}

struct SelectableOption: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let symbol: String
    let palette: PortfolioPalette
}

enum BeautySpecialty: String, CaseIterable, Identifiable, Hashable {
    case nails = "Nails"
    case hair = "Hair"
    case makeup = "Makeup"
    case browsLashes = "Brows & Lashes"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .nails: "sparkles"
        case .hair: "comb.fill"
        case .makeup: "paintbrush.pointed.fill"
        case .browsLashes: "eye.fill"
        }
    }
}

enum DepartmentStatus: Hashable {
    case active
    case comingSoon
}

struct Department: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let symbol: String
    let status: DepartmentStatus
}

struct BeautyCategory: Identifiable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let specialty: BeautySpecialty
}

enum ProviderBadge: String, Identifiable, Hashable {
    case topRated = "Top Rated"
    case repeatFavorite = "Repeat Favorite"
    case fastResponse = "Fast Response"

    var id: String { rawValue }
}

struct ServiceItem: Identifiable, Hashable {
    let id: String
    let name: String
    let specialty: BeautySpecialty
    let duration: String
    let startingPrice: Int
}

struct AvailabilitySlot: Identifiable, Hashable {
    let id: String
    let label: String
    let time: String
}

struct Review: Identifiable, Hashable {
    let id: String
    let author: String
    let rating: Double
    let date: String
    let text: String
}

struct PortfolioWork: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let symbol: String
    let palette: PortfolioPalette
}

enum PortfolioPalette: String, Hashable {
    case rose
    case olive
    case clay
    case ink
    case gold
    case ocean
    case sand
}

struct TrustBadge: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let symbol: String
}

struct Provider: Identifiable, Hashable {
    let id: String
    let name: String
    let initials: String
    let neighborhood: String
    let specialties: [BeautySpecialty]
    let rating: Double
    let completedJobs: Int
    let responseTime: String
    let punctualityScore: Int
    let startingPrice: Int
    let bio: String
    let serviceTags: [String]
    let badges: [ProviderBadge]
    let services: [ServiceItem]
    let availability: [AvailabilitySlot]
    let reviews: [Review]
    let portfolio: [PortfolioWork]
    let trustBadges: [TrustBadge]
    let avatarPalette: PortfolioPalette
}

enum BeautyFilter: String, CaseIterable, Identifiable, Hashable {
    case nails = "Nails"
    case hair = "Hair"
    case makeup = "Makeup"
    case availableToday = "Available Today"
    case nearMe = "Near Me"
    case under250 = "Under 250 MAD"
    case under350 = "Under 350 MAD"
    case verifiedOnly = "Verified Only"

    var id: String { rawValue }
}

enum BeautySortOption: String, CaseIterable, Identifiable {
    case recommended = "Recommended"
    case earliest = "Earliest Available"
    case topRated = "Top Rated"
    case lowestPrice = "Lowest Starting Price"

    var id: String { rawValue }
}

enum BookingStatus: String, CaseIterable, Identifiable, Hashable {
    case upcoming = "Upcoming"
    case past = "Past"
    case cancelled = "Cancelled"

    var id: String { rawValue }
}

enum PaymentMethod: String, CaseIterable, Identifiable, Hashable {
    case cash = "Cash after service"
    case card = "Card"

    var id: String { rawValue }
}

struct Booking: Identifiable, Hashable {
    let id: String
    let providerID: String
    let serviceName: String
    let dateLabel: String
    let timeLabel: String
    let address: String
    let price: Int
    var status: BookingStatus
    let paymentMethod: PaymentMethod
    let note: String
}

struct CustomerProfile: Hashable {
    let name: String
    let phone: String
    let city: String
    let savedAddresses: [String]
    let paymentMethods: [String]
    let supportHistory: [String]
}

struct OnboardingStep: Identifiable, Hashable {
    let id: String
    let title: String
    let detail: String
    let symbol: String
}

struct CoverageZone: Identifiable, Hashable {
    let id: String
    let neighborhood: String
    let providerCount: Int
    let activeServices: [BeautySpecialty]
    let etaRange: String
    let mapX: Double
    let mapY: Double
    let palette: PortfolioPalette
}

enum ChatSender: Hashable {
    case customer
    case provider
    case coordinator
}

struct ChatMessage: Identifiable, Hashable {
    let id: String
    let sender: ChatSender
    let providerID: String?
    let textFR: String
    let textAR: String
    let time: String
}
