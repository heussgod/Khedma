import SwiftUI

struct BookingFlowView: View {
    @EnvironmentObject private var preferences: AppPreferences
    @EnvironmentObject private var bookings: BookingsViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: BookingFlowViewModel

    init(provider: Provider) {
        _viewModel = StateObject(wrappedValue: BookingFlowViewModel(provider: provider))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    stepHeader
                    stepContent
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, viewModel.step == .success ? 36 : 120)
            }
            .background(KhedmaBackground())
        }
        .navigationTitle(preferences.language.copy(fr: "Réserver", ar: "الحجز"))
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            if viewModel.step != .success {
                bottomAction
            }
        }
    }

    private var stepHeader: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                ProviderAvatarView(provider: viewModel.provider, size: 54)
                VStack(alignment: .leading, spacing: 3) {
                    Text(KhedmaCopy.providerName(viewModel.provider, language: preferences.language))
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(KhedmaTheme.ink)
                    Text(preferences.language.copy(fr: "Suivi humain Khedma inclus", ar: "متابعة فريق خدمة مشمولة"))
                        .font(.caption)
                        .foregroundStyle(KhedmaTheme.muted)
                }
                Spacer()
                TrustPill(text: preferences.language.copy(fr: "Vérifiée", ar: "موثقة"))
            }

            HStack(spacing: 6) {
                ForEach(BookingFlowViewModel.Step.allCases.filter { $0 != .success }, id: \.rawValue) { step in
                    Capsule()
                        .fill(step.rawValue <= viewModel.step.rawValue ? KhedmaTheme.accent : KhedmaTheme.line)
                        .frame(height: 5)
                }
            }

            Text(stepTitle(viewModel.step))
                .font(.title2.weight(.bold))
                .foregroundStyle(KhedmaTheme.ink)
        }
        .background(alignment: .topTrailing) {
            VisualAccentRibbon(palette: viewModel.provider.avatarPalette)
                .frame(width: 150, height: 90)
                .opacity(0.18)
                .offset(x: 28, y: -16)
        }
        .khedmaCard(padding: 18)
    }

    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.step {
        case .service:
            serviceStep
        case .schedule:
            scheduleStep
        case .address:
            addressStep
        case .payment:
            paymentStep
        case .summary:
            summaryStep
        case .success:
            successStep
        }
    }

    private var serviceStep: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(preferences.language.copy(fr: "Choisir un service", ar: "اختيار خدمة"))
                .font(.headline.weight(.semibold))
                .foregroundStyle(KhedmaTheme.ink)
            ForEach(viewModel.provider.services) { service in
                Button {
                    withAnimation(.snappy) {
                        viewModel.selectedService = service
                    }
                    triggerSoftHaptic()
                } label: {
                    SelectionRow(
                        title: KhedmaCopy.serviceName(service.id, fallback: service.name, language: preferences.language),
                        subtitle: "\(KhedmaCopy.duration(service.duration, language: preferences.language)) · \(KhedmaCopy.specialty(service.specialty, language: preferences.language))",
                        trailing: "\(service.startingPrice) \(preferences.language == .arabic ? "درهم" : "MAD")",
                        isSelected: viewModel.selectedService == service
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var scheduleStep: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(preferences.language.copy(fr: "Choisir un créneau vérifié", ar: "اختيار موعد موثوق"))
                .font(.headline.weight(.semibold))
                .foregroundStyle(KhedmaTheme.ink)
            ForEach(viewModel.provider.availability) { slot in
                Button {
                    withAnimation(.snappy) {
                        viewModel.selectedSlot = slot
                    }
                    triggerSoftHaptic()
                } label: {
                    SelectionRow(
                        title: KhedmaCopy.availabilityLabel(slot.label, language: preferences.language),
                        subtitle: preferences.language.copy(fr: "Confirmation par l’équipe après la demande", ar: "تأكيد من الفريق بعد الطلب"),
                        trailing: slot.time,
                        isSelected: viewModel.selectedSlot == slot
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var addressStep: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(preferences.language.copy(fr: "Choisir l’adresse", ar: "اختيار العنوان"))
                .font(.headline.weight(.semibold))
                .foregroundStyle(KhedmaTheme.ink)
            ForEach(MockData.profile.savedAddresses, id: \.self) { address in
                Button {
                    withAnimation(.snappy) {
                        viewModel.selectedAddress = address
                    }
                    triggerSoftHaptic()
                } label: {
                    SelectionRow(
                        title: KhedmaCopy.bookingAddress(address, language: preferences.language),
                        subtitle: KhedmaCopy.city("Casablanca", language: preferences.language),
                        trailing: "",
                        isSelected: viewModel.selectedAddress == address
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var paymentStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(preferences.language.copy(fr: "Mode de paiement", ar: "طريقة الدفع"))
                .font(.headline.weight(.semibold))
                .foregroundStyle(KhedmaTheme.ink)
            ForEach(PaymentMethod.allCases) { method in
                Button {
                    viewModel.paymentMethod = method
                    triggerSoftHaptic()
                } label: {
                    SelectionRow(
                        title: KhedmaCopy.paymentMethod(method, language: preferences.language),
                        subtitle: method == .card ? preferences.language.copy(fr: "Carte enregistrée pour simulation", ar: "بطاقة محفوظة للمحاكاة") : preferences.language.copy(fr: "Option privilégiée au lancement", ar: "الخيار المعتمد في الإطلاق"),
                        trailing: "",
                        isSelected: viewModel.paymentMethod == method
                    )
                }
                .buttonStyle(.plain)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(preferences.language.copy(fr: "Notes optionnelles", ar: "ملاحظات اختيارية"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(KhedmaTheme.ink)
                TextEditor(text: $viewModel.note)
                    .frame(minHeight: 110)
                    .scrollContentBackground(.hidden)
                    .padding(10)
                    .background(KhedmaTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(KhedmaTheme.line, lineWidth: 1)
                    )
            }
        }
    }

    private var summaryStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(preferences.language.copy(fr: "Vérifier la réservation", ar: "مراجعة الحجز"))
                .font(.headline.weight(.semibold))
                .foregroundStyle(KhedmaTheme.ink)
            VStack(spacing: 12) {
                SummaryRow(title: preferences.language.copy(fr: "Professionnelle", ar: "المهنية"), detail: KhedmaCopy.providerName(viewModel.provider, language: preferences.language))
                SummaryRow(title: preferences.language.copy(fr: "Service", ar: "الخدمة"), detail: KhedmaCopy.serviceName(viewModel.selectedService.id, fallback: viewModel.selectedService.name, language: preferences.language))
                SummaryRow(title: preferences.language.copy(fr: "Quand", ar: "الموعد"), detail: "\(KhedmaCopy.availabilityLabel(viewModel.selectedSlot.label, language: preferences.language)), \(viewModel.selectedSlot.time)")
                SummaryRow(title: preferences.language.copy(fr: "Adresse", ar: "العنوان"), detail: KhedmaCopy.bookingAddress(viewModel.selectedAddress, language: preferences.language))
                SummaryRow(title: preferences.language.copy(fr: "Paiement", ar: "الدفع"), detail: KhedmaCopy.paymentMethod(viewModel.paymentMethod, language: preferences.language))
                SummaryRow(title: preferences.language.copy(fr: "Total estimé", ar: "المجموع التقديري"), detail: "\(viewModel.selectedService.startingPrice) \(preferences.language == .arabic ? "درهم" : "MAD")", isStrong: true)
            }
            .khedmaCard()

            WhatsAppOperatorBubble()
        }
    }

    private var successStep: some View {
        VStack(spacing: 18) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 58, weight: .semibold))
                .foregroundStyle(KhedmaTheme.success)
                .frame(width: 108, height: 108)
                .background(KhedmaTheme.success.opacity(0.10))
                .clipShape(Circle())

            VStack(spacing: 8) {
                Text(preferences.language.copy(fr: "Demande envoyée", ar: "تم إرسال الطلب"))
                    .font(.title2.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(preferences.language.copy(fr: "Khedma confirmera le rendez-vous et restera disponible jusqu’à la fin du service.", ar: "ستؤكد خدمة الموعد وتبقى متاحة حتى نهاية الخدمة."))
                    .font(.subheadline)
                    .foregroundStyle(KhedmaTheme.muted)
                    .multilineTextAlignment(.center)
            }

            WhatsAppOperatorBubble()

            Button {
                dismiss()
            } label: {
                Text(preferences.language.copy(fr: "Terminé", ar: "تم"))
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(KhedmaTheme.accentDeep)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .khedmaCard(padding: 22)
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Divider().overlay(KhedmaTheme.line)
            HStack(spacing: 12) {
                if viewModel.step.rawValue > 0 {
                    Button {
                        withAnimation(.snappy) {
                            viewModel.back()
                        }
                    } label: {
                        Text(preferences.language.copy(fr: "Retour", ar: "رجوع"))
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(KhedmaTheme.ink)
                            .frame(width: 86)
                            .padding(.vertical, 15)
                            .background(KhedmaTheme.surfaceWarm)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    if viewModel.step == .summary {
                        bookings.addConfirmedBooking(
                            provider: viewModel.provider,
                            service: viewModel.selectedService,
                            slot: viewModel.selectedSlot,
                            address: viewModel.selectedAddress,
                            paymentMethod: viewModel.paymentMethod,
                            note: viewModel.note
                        )
                        triggerSoftHaptic()
                        withAnimation(.snappy) {
                            viewModel.step = .success
                        }
                    } else {
                        withAnimation(.snappy) {
                            viewModel.advance()
                        }
                    }
                } label: {
                    Text(viewModel.step == .summary ? preferences.language.copy(fr: "Confirmer", ar: "تأكيد") : preferences.language.copy(fr: "Continuer", ar: "متابعة"))
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(KhedmaTheme.accentDeep)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
        }
    }

    private func stepTitle(_ step: BookingFlowViewModel.Step) -> String {
        switch step {
        case .service: return preferences.language.copy(fr: "Service", ar: "الخدمة")
        case .schedule: return preferences.language.copy(fr: "Créneau", ar: "الموعد")
        case .address: return preferences.language.copy(fr: "Adresse", ar: "العنوان")
        case .payment: return preferences.language.copy(fr: "Paiement", ar: "الدفع")
        case .summary: return preferences.language.copy(fr: "Résumé", ar: "الملخص")
        case .success: return preferences.language.copy(fr: "Confirmé", ar: "تم التأكيد")
        }
    }
}

struct SelectionRow: View {
    let title: String
    let subtitle: String
    let trailing: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isSelected ? KhedmaTheme.success : KhedmaTheme.muted)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(KhedmaTheme.ink)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(KhedmaTheme.muted)
                }
            }
            Spacer()
            if !trailing.isEmpty {
                Text(trailing)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.accentDeep)
            }
        }
        .padding(15)
        .background(isSelected ? KhedmaTheme.accent.opacity(0.12) : KhedmaTheme.surface.opacity(0.86))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(isSelected ? KhedmaTheme.accent.opacity(0.7) : KhedmaTheme.line, lineWidth: 1)
        )
    }
}

struct SummaryRow: View {
    let title: String
    let detail: String
    var isStrong = false

    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(KhedmaTheme.muted)
            Spacer()
            Text(detail)
                .font(.subheadline.weight(isStrong ? .bold : .semibold))
                .foregroundStyle(isStrong ? KhedmaTheme.accentDeep : KhedmaTheme.ink)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview("Booking Flow") {
    NavigationStack {
        BookingFlowView(provider: MockData.providers[0])
    }
    .khedmaPreviewEnvironment()
}
