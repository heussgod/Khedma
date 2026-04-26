import SwiftUI

@MainActor
final class AppPreferences: ObservableObject {
    @Published var language: KhedmaLanguage {
        didSet { persist(language.rawValue, key: Keys.language) }
    }
    @Published var role: UserRole? {
        didSet { persist(role?.rawValue, key: Keys.role) }
    }
    @Published var selectedInterestIDs: [String] {
        didSet { persist(selectedInterestIDs, key: Keys.interests) }
    }
    @Published var city: String {
        didSet { persist(city, key: Keys.city) }
    }
    @Published var neighborhood: String {
        didSet { persist(neighborhood, key: Keys.neighborhood) }
    }
    @Published var hasCompletedOnboarding: Bool {
        didSet { persist(hasCompletedOnboarding, key: Keys.completed) }
    }
    @Published var workerApplicationStatus: ApplicationStatus {
        didSet { persist(workerApplicationStatus.rawValue, key: Keys.workerStatus) }
    }

    private let usesPersistence: Bool

    init(
        language: KhedmaLanguage? = nil,
        role: UserRole? = nil,
        selectedInterestIDs: [String]? = nil,
        city: String? = nil,
        neighborhood: String? = nil,
        hasCompletedOnboarding: Bool? = nil,
        workerApplicationStatus: ApplicationStatus? = nil,
        usesPersistence: Bool = true
    ) {
        self.usesPersistence = usesPersistence
        let defaults = UserDefaults.standard
        self.language = language
            ?? KhedmaLanguage(rawValue: defaults.string(forKey: Keys.language) ?? "")
            ?? .french
        self.role = role ?? UserRole(rawValue: defaults.string(forKey: Keys.role) ?? "")
        self.selectedInterestIDs = selectedInterestIDs ?? (defaults.array(forKey: Keys.interests) as? [String] ?? [])
        self.city = city ?? defaults.string(forKey: Keys.city) ?? "Casablanca"
        self.neighborhood = neighborhood ?? defaults.string(forKey: Keys.neighborhood) ?? "Maarif"
        self.hasCompletedOnboarding = hasCompletedOnboarding ?? defaults.bool(forKey: Keys.completed)
        self.workerApplicationStatus = workerApplicationStatus
            ?? ApplicationStatus(rawValue: defaults.string(forKey: Keys.workerStatus) ?? "")
            ?? .underReview
    }

    var layoutDirection: LayoutDirection {
        language.isRTL ? .rightToLeft : .leftToRight
    }

    func resetOnboarding() {
        role = nil
        selectedInterestIDs = []
        city = "Casablanca"
        neighborhood = "Maarif"
        workerApplicationStatus = .underReview
        hasCompletedOnboarding = false
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
    }

    static let previewCustomer = AppPreferences(
        role: .customer,
        selectedInterestIDs: ["beauty"],
        hasCompletedOnboarding: true,
        usesPersistence: false
    )

    static let previewWorker = AppPreferences(
        role: .worker,
        selectedInterestIDs: ["nails", "makeup"],
        hasCompletedOnboarding: true,
        usesPersistence: false
    )

    static let previewOnboarding = AppPreferences(
        hasCompletedOnboarding: false,
        usesPersistence: false
    )

    private func persist(_ value: Any?, key: String) {
        guard usesPersistence else { return }
        if let value {
            UserDefaults.standard.set(value, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    private enum Keys {
        static let language = "khedma.language"
        static let role = "khedma.role"
        static let interests = "khedma.interests"
        static let city = "khedma.city"
        static let neighborhood = "khedma.neighborhood"
        static let completed = "khedma.onboarding.completed"
        static let workerStatus = "khedma.worker.status"
    }
}
