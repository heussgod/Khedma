import Foundation

@MainActor
final class ProviderListViewModel: ObservableObject {
    @Published var providers: [Provider]
    @Published var isLoading: Bool
    private var didLoad = false

    init(providers: [Provider] = MockData.providers, isLoading: Bool = true) {
        self.providers = providers
        self.isLoading = isLoading
    }

    static func previewLoaded() -> ProviderListViewModel {
        ProviderListViewModel(isLoading: false)
    }

    func loadIfNeeded() async {
        guard !didLoad else {
            isLoading = false
            return
        }
        isLoading = true
        try? await Task.sleep(nanoseconds: 450_000_000)
        providers = MockData.providers
        isLoading = false
        didLoad = true
    }

    func provider(id: String) -> Provider? {
        providers.first { $0.id == id }
    }

    func filteredProviders(filters: Set<BeautyFilter>, sort: BeautySortOption) -> [Provider] {
        var result = providers

        if filters.contains(.nails) {
            result = result.filter { $0.specialties.contains(.nails) }
        }
        if filters.contains(.hair) {
            result = result.filter { $0.specialties.contains(.hair) }
        }
        if filters.contains(.makeup) {
            result = result.filter { $0.specialties.contains(.makeup) }
        }
        if filters.contains(.availableToday) {
            result = result.filter { provider in
                provider.availability.contains { $0.label == "Today" }
            }
        }
        if filters.contains(.nearMe) {
            result = result.filter { ["Maarif", "Gauthier", "Anfa"].contains($0.neighborhood) }
        }
        if filters.contains(.under250) {
            result = result.filter { $0.startingPrice < 250 }
        }
        if filters.contains(.under350) {
            result = result.filter { $0.startingPrice < 350 }
        }

        // Every listed provider is verified; the chip is kept to reinforce the curated model.
        if filters.contains(.verifiedOnly) {
            result = result.filter { !$0.trustBadges.isEmpty }
        }

        switch sort {
        case .recommended:
            return result.sorted { lhs, rhs in
                let lhsScore = lhs.rating + Double(lhs.completedJobs) / 1000
                let rhsScore = rhs.rating + Double(rhs.completedJobs) / 1000
                return lhsScore > rhsScore
            }
        case .earliest:
            return result.sorted { lhs, rhs in
                let lhsToday = lhs.availability.contains { $0.label == "Today" }
                let rhsToday = rhs.availability.contains { $0.label == "Today" }
                return lhsToday && !rhsToday
            }
        case .topRated:
            return result.sorted { $0.rating > $1.rating }
        case .lowestPrice:
            return result.sorted { $0.startingPrice < $1.startingPrice }
        }
    }
}

@MainActor
final class BookingsViewModel: ObservableObject {
    @Published var bookings: [Booking]

    init(bookings: [Booking] = MockData.bookings) {
        self.bookings = bookings
    }

    static let preview = BookingsViewModel()

    func bookings(for status: BookingStatus) -> [Booking] {
        bookings.filter { $0.status == status }
    }

    func addConfirmedBooking(provider: Provider, service: ServiceItem, slot: AvailabilitySlot, address: String, paymentMethod: PaymentMethod, note: String) {
        let booking = Booking(
            id: UUID().uuidString,
            providerID: provider.id,
            serviceName: service.name,
            dateLabel: slot.label,
            timeLabel: slot.time,
            address: address,
            price: service.startingPrice,
            status: .upcoming,
            paymentMethod: paymentMethod,
            note: note
        )
        bookings.insert(booking, at: 0)
    }

    func cancel(_ booking: Booking) {
        guard let index = bookings.firstIndex(where: { $0.id == booking.id }) else { return }
        bookings[index].status = .cancelled
    }
}

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var savedProviderIDs: Set<String>
    @Published var recentlyViewedProviderIDs: [String]

    init(savedProviderIDs: Set<String> = ["yasmina", "soukaina", "fatima"], recentlyViewedProviderIDs: [String] = ["imanes", "hiba", "asmae"]) {
        self.savedProviderIDs = savedProviderIDs
        self.recentlyViewedProviderIDs = recentlyViewedProviderIDs
    }

    static let preview = FavoritesViewModel()

    func isFavorite(_ provider: Provider) -> Bool {
        savedProviderIDs.contains(provider.id)
    }

    func toggle(_ provider: Provider) {
        if savedProviderIDs.contains(provider.id) {
            savedProviderIDs.remove(provider.id)
        } else {
            savedProviderIDs.insert(provider.id)
        }
    }

    func noteViewed(_ provider: Provider) {
        recentlyViewedProviderIDs.removeAll { $0 == provider.id }
        recentlyViewedProviderIDs.insert(provider.id, at: 0)
        recentlyViewedProviderIDs = Array(recentlyViewedProviderIDs.prefix(5))
    }
}

@MainActor
final class BookingFlowViewModel: ObservableObject {
    enum Step: Int, CaseIterable {
        case service
        case schedule
        case address
        case payment
        case summary
        case success

        var title: String {
            switch self {
            case .service: "Service"
            case .schedule: "Créneau"
            case .address: "Adresse"
            case .payment: "Paiement"
            case .summary: "Résumé"
            case .success: "Confirmé"
            }
        }
    }

    let provider: Provider
    @Published var step: Step = .service
    @Published var selectedService: ServiceItem
    @Published var selectedSlot: AvailabilitySlot
    @Published var selectedAddress: String = MockData.profile.savedAddresses[0]
    @Published var paymentMethod: PaymentMethod = .cash
    @Published var note: String = ""

    init(provider: Provider) {
        self.provider = provider
        selectedService = provider.services[0]
        selectedSlot = provider.availability[0]
    }

    func advance() {
        guard let next = Step(rawValue: step.rawValue + 1) else { return }
        step = next
    }

    func back() {
        guard let previous = Step(rawValue: step.rawValue - 1) else { return }
        step = previous
    }
}
