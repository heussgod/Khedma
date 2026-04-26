import SwiftUI

struct BookingsView: View {
    @EnvironmentObject private var preferences: AppPreferences
    @EnvironmentObject private var bookings: BookingsViewModel
    @EnvironmentObject private var providerList: ProviderListViewModel
    @State private var selectedStatus: BookingStatus = .upcoming

    var body: some View {
        VStack(spacing: 0) {
            header
            Picker(preferences.language.copy(fr: "Statut", ar: "الحالة"), selection: $selectedStatus) {
                ForEach(BookingStatus.allCases) { status in
                    Text(KhedmaCopy.bookingStatus(status, language: preferences.language)).tag(status)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)
            .padding(.bottom, 12)

            List {
                if displayedBookings.isEmpty {
                    EmptyComingSoonView(
                        title: preferences.language.copy(fr: "Aucune réservation", ar: "لا توجد حجوزات"),
                        detail: preferences.language.copy(fr: "Vos rendez-vous suivis par Khedma apparaîtront ici.", ar: "ستظهر هنا مواعيدك المدعومة من خدمة.")
                    )
                    .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(displayedBookings) { booking in
                        NavigationLink {
                            BookingDetailView(booking: booking)
                        } label: {
                            BookingCard(booking: booking, provider: providerList.provider(id: booking.providerID))
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            if booking.status == .upcoming {
                                Button(preferences.language.copy(fr: "Annuler", ar: "إلغاء"), role: .destructive) {
                                    bookings.cancel(booking)
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    if selectedStatus == .upcoming {
                        BookingOperationsHint()
                            .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .safeAreaPadding(.bottom, 96)
        }
        .background(KhedmaBackground())
        .navigationTitle(preferences.language.copy(fr: "Réservations", ar: "الحجوزات"))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    TrustPill(text: preferences.language.copy(fr: "Suivi inclus", ar: "متابعة مشمولة"), symbol: "checkmark.shield.fill", tint: KhedmaTheme.olive)
                    Text(preferences.language.copy(fr: "Vos réservations", ar: "حجوزاتك"))
                        .font(KhedmaFont.hero(25))
                        .foregroundStyle(KhedmaTheme.ink)
                    Text(preferences.language.copy(fr: "Créneau, contact, adresse et assistance au même endroit.", ar: "الموعد، التواصل، العنوان والمساعدة في مكان واحد."))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(KhedmaTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Image(systemName: "calendar.badge.clock")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(KhedmaTheme.olive)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }

            HStack(spacing: 10) {
                PremiumMetricTile(value: "\(bookings.bookings(for: .upcoming).count)", label: preferences.language.copy(fr: "à venir", ar: "قادمة"), symbol: "calendar")
                PremiumMetricTile(value: "\(bookings.bookings(for: .past).count)", label: preferences.language.copy(fr: "passées", ar: "سابقة"), symbol: "clock.arrow.circlepath")
                PremiumMetricTile(value: preferences.language.copy(fr: "incluse", ar: "مشمولة"), label: preferences.language.copy(fr: "assistance", ar: "مساعدة"), symbol: "headset")
            }
        }
        .khedmaCard(padding: 16)
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }

    private var displayedBookings: [Booking] {
        bookings.bookings(for: selectedStatus)
    }
}

struct BookingCard: View {
    @EnvironmentObject private var preferences: AppPreferences
    let booking: Booking
    let provider: Provider?

    var body: some View {
        HStack(spacing: 14) {
            if let provider {
                ProviderAvatarView(provider: provider, size: 62)
            } else {
                Image(systemName: "calendar.badge.clock")
                    .foregroundStyle(KhedmaTheme.accent)
                    .frame(width: 62, height: 62)
                    .background(KhedmaTheme.surfaceWarm)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }

            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text(KhedmaCopy.bookingService(booking, language: preferences.language))
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(KhedmaTheme.ink)
                    Spacer()
                    BookingStatusPill(status: booking.status)
                }
                Text(provider.map { KhedmaCopy.providerName($0, language: preferences.language) } ?? preferences.language.copy(fr: "Professionnelle Khedma", ar: "مهنية خدمة"))
                    .font(.subheadline)
                    .foregroundStyle(KhedmaTheme.muted)
                HStack(spacing: 10) {
                    Label("\(KhedmaCopy.bookingDate(booking.dateLabel, language: preferences.language)), \(booking.timeLabel)", systemImage: "clock")
                    Text("\(booking.price) \(preferences.language == .arabic ? "درهم" : "MAD")")
                }
                .font(.caption.weight(.medium))
                .foregroundStyle(KhedmaTheme.muted)
                FlowTagRow(tags: booking.status == .upcoming ? upcomingActions : pastActions)
            }
        }
        .khedmaCard()
    }

    private var upcomingActions: [String] {
        [
            preferences.language.copy(fr: "Message", ar: "رسالة"),
            preferences.language.copy(fr: "Déplacer", ar: "تغيير الموعد"),
            preferences.language.copy(fr: "Assistance", ar: "مساعدة")
        ]
    }

    private var pastActions: [String] {
        booking.status == .cancelled
            ? [preferences.language.copy(fr: "Annulée", ar: "ملغاة"), preferences.language.copy(fr: "Assistance", ar: "المساعدة")]
            : [preferences.language.copy(fr: "Réserver à nouveau", ar: "حجز جديد"), preferences.language.copy(fr: "Reçu", ar: "الإيصال")]
    }
}

private struct BookingOperationsHint: View {
    @EnvironmentObject private var preferences: AppPreferences

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: preferences.language.copy(fr: "Suivi du prochain rendez-vous", ar: "متابعة الموعد القادم"))
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(KhedmaTheme.ocean)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                VStack(alignment: .leading, spacing: 5) {
                    Text(preferences.language.copy(fr: "Le fil de discussion s’ouvre après confirmation.", ar: "تفتح المحادثة بعد التأكيد."))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(KhedmaTheme.ink)
                    Text(preferences.language.copy(fr: "Adresse, retard, changement de créneau ou question prix passent par ce suivi.", ar: "العنوان، التأخير، تغيير الموعد أو سؤال السعر تتم عبر هذه المتابعة."))
                        .font(.caption)
                        .foregroundStyle(KhedmaTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .khedmaCard()
    }
}

struct BookingDetailView: View {
    @EnvironmentObject private var preferences: AppPreferences
    @EnvironmentObject private var providerList: ProviderListViewModel
    let booking: Booking

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                if let provider {
                    HStack(spacing: 14) {
                        ProviderAvatarView(provider: provider, size: 76)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(KhedmaCopy.providerName(provider, language: preferences.language))
                                .font(.title3.weight(.bold))
                                .foregroundStyle(KhedmaTheme.ink)
                            TrustPill(text: preferences.language.copy(fr: "Vérifiée", ar: "موثقة"))
                            Text(KhedmaCopy.neighborhood(provider.neighborhood, language: preferences.language))
                                .font(.caption)
                                .foregroundStyle(KhedmaTheme.muted)
                        }
                        Spacer()
                    }
                    .khedmaCard()
                }

                VStack(spacing: 12) {
                    SummaryRow(title: preferences.language.copy(fr: "Service", ar: "الخدمة"), detail: KhedmaCopy.bookingService(booking, language: preferences.language))
                    SummaryRow(title: preferences.language.copy(fr: "Statut", ar: "الحالة"), detail: KhedmaCopy.bookingStatus(booking.status, language: preferences.language))
                    SummaryRow(title: preferences.language.copy(fr: "Quand", ar: "الموعد"), detail: "\(KhedmaCopy.bookingDate(booking.dateLabel, language: preferences.language)), \(booking.timeLabel)")
                    SummaryRow(title: preferences.language.copy(fr: "Adresse", ar: "العنوان"), detail: KhedmaCopy.bookingAddress(booking.address, language: preferences.language))
                    SummaryRow(title: preferences.language.copy(fr: "Paiement", ar: "الدفع"), detail: KhedmaCopy.paymentMethod(booking.paymentMethod, language: preferences.language))
                    SummaryRow(title: preferences.language.copy(fr: "Prix", ar: "السعر"), detail: "\(booking.price) \(preferences.language == .arabic ? "درهم" : "MAD")", isStrong: true)
                    if !booking.note.isEmpty {
                        SummaryRow(title: preferences.language.copy(fr: "Note", ar: "ملاحظة"), detail: KhedmaCopy.bookingNote(booking.note, language: preferences.language))
                    }
                }
                .khedmaCard()

                WhatsAppOperatorBubble()

                if let provider {
                    NavigationLink {
                        ProviderChatView(provider: provider)
                    } label: {
                        HStack {
                            Image(systemName: "message.fill")
                            Text(preferences.language.copy(fr: "Message sécurisé", ar: "رسالة آمنة"))
                                .font(.headline.weight(.semibold))
                            Spacer()
                            Image(systemName: preferences.language.isRTL ? "chevron.left" : "chevron.right")
                        }
                        .foregroundStyle(KhedmaTheme.accentDeep)
                        .khedmaCard()
                    }
                    .buttonStyle(.plain)
                }

                if booking.status == .past, let provider {
                    NavigationLink {
                        BookingFlowView(provider: provider)
                    } label: {
                        Text(preferences.language.copy(fr: "Réserver à nouveau", ar: "الحجز مرة أخرى"))
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(KhedmaTheme.accentDeep)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .background(KhedmaBackground())
        .navigationTitle(preferences.language.copy(fr: "Détail", ar: "التفاصيل"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var provider: Provider? {
        providerList.provider(id: booking.providerID)
    }
}

#Preview("Bookings") {
    NavigationStack {
        BookingsView()
    }
    .khedmaPreviewEnvironment()
}
