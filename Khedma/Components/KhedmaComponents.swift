import SwiftUI

struct SectionHeader: View {
    let title: String
    var action: String?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                Capsule()
                    .fill(LinearGradient(colors: [KhedmaTheme.accent, KhedmaTheme.gold], startPoint: .leading, endPoint: .trailing))
                    .frame(width: 28, height: 3)
            }
            Spacer()
            if let action {
                Text(action)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(KhedmaTheme.accentDeep)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 8)
                    .background(KhedmaTheme.surface.opacity(0.78))
                    .clipShape(Capsule())
            }
        }
    }
}

struct TrustPill: View {
    let text: String
    var symbol: String = "checkmark.seal.fill"
    var tint: Color = KhedmaTheme.success

    var body: some View {
        Label(text, systemImage: symbol)
            .font(.caption.weight(.semibold))
            .foregroundStyle(tint)
            .lineLimit(1)
            .minimumScaleFactor(0.76)
            .padding(.horizontal, 11)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(tint.opacity(0.12))
                    .background(.ultraThinMaterial, in: Capsule())
            )
            .overlay(Capsule().stroke(.white.opacity(0.55), lineWidth: 1))
            .clipShape(Capsule())
    }
}

struct ServiceChip: View {
    let title: String
    var isSelected = false

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(isSelected ? .white : KhedmaTheme.ink.opacity(0.86))
            .padding(.horizontal, 13)
            .padding(.vertical, 9)
            .background(
                Capsule()
                    .fill(isSelected ? KhedmaTheme.accentDeep : KhedmaTheme.surface.opacity(0.86))
                    .shadow(color: isSelected ? KhedmaTheme.accent.opacity(0.18) : .clear, radius: 12, x: 0, y: 8)
            )
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(isSelected ? KhedmaTheme.gold.opacity(0.5) : .white.opacity(0.75), lineWidth: 1)
            )
    }
}

struct PrimaryButton: View {
    @EnvironmentObject private var preferences: AppPreferences
    let title: String
    var subtitle: String?
    var symbol: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let symbol {
                    Image(systemName: symbol)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline.weight(.semibold))
                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .opacity(0.85)
                    }
                }
                Spacer()
                Image(systemName: preferences.language.isRTL ? "arrow.left" : "arrow.right")
                    .font(.subheadline.weight(.bold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                LinearGradient(colors: [KhedmaTheme.accentDeep, KhedmaTheme.merlot, KhedmaTheme.clay], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(.white.opacity(0.26), lineWidth: 1)
            )
            .shadow(color: KhedmaTheme.accentDeep.opacity(0.22), radius: 18, x: 0, y: 12)
        }
        .subtlePressScale()
    }
}

struct ProviderAvatarView: View {
    let provider: Provider
    var size: CGFloat = 72

    var body: some View {
        Image(KhedmaCopy.providerImageAsset(provider))
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [.clear, KhedmaTheme.ink.opacity(0.16)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: size * 0.52)
            }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                .stroke(.white.opacity(0.72), lineWidth: 1)
        )
        .shadow(color: KhedmaTheme.ink.opacity(0.12), radius: size * 0.16, x: 0, y: size * 0.10)
    }
}

struct PortfolioTile: View {
    @EnvironmentObject private var preferences: AppPreferences
    let item: PortfolioWork

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(KhedmaCopy.portfolioImageAsset(item))
                .resizable()
                .scaledToFill()
            LinearGradient(
                colors: [.black.opacity(0.03), .black.opacity(0.66)],
                startPoint: .top,
                endPoint: .bottom
            )
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: item.symbol)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.88))
                Text(KhedmaCopy.portfolioTitle(item, language: preferences.language))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                Text(KhedmaCopy.portfolioSubtitle(item, language: preferences.language))
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.78))
            }
            .padding(14)
        }
        .frame(width: 150, height: 170, alignment: .bottomLeading)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.42), lineWidth: 1)
        )
        .shadow(color: KhedmaTheme.ink.opacity(0.12), radius: 16, x: 0, y: 10)
    }
}

struct ProviderCard: View {
    @EnvironmentObject private var preferences: AppPreferences
    let provider: Provider
    var isFavorite = false
    var onFavorite: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(alignment: .top, spacing: 14) {
                ZStack(alignment: .bottomTrailing) {
                    ProviderAvatarView(provider: provider, size: 72)
                    Image(systemName: "checkmark.seal.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(5)
                        .background(KhedmaTheme.success)
                        .clipShape(Circle())
                        .offset(x: 4, y: 4)
                }
                VStack(alignment: .leading, spacing: 7) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(KhedmaCopy.providerName(provider, language: preferences.language))
                                .font(.headline.weight(.bold))
                                .foregroundStyle(KhedmaTheme.ink)
                            Text(KhedmaCopy.neighborhood(provider.neighborhood, language: preferences.language))
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(KhedmaTheme.muted)
                        }
                        Spacer()
                        if let onFavorite {
                            Button(action: onFavorite) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .foregroundStyle(isFavorite ? KhedmaTheme.accent : KhedmaTheme.muted)
                                    .frame(width: 34, height: 34)
                                    .background(KhedmaTheme.surfaceWarm.opacity(0.92))
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(.white.opacity(0.7), lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    HStack(spacing: 8) {
                        Label(String(format: "%.2f", provider.rating), systemImage: "star.fill")
                        Text(preferences.language.copy(fr: "\(provider.completedJobs) services", ar: "\(provider.completedJobs) خدمة"))
                        Text(preferences.language.copy(fr: "répond \(KhedmaCopy.responseTime(provider.responseTime, language: preferences.language))", ar: "رد خلال \(KhedmaCopy.responseTime(provider.responseTime, language: preferences.language))"))
                    }
                    .font(.caption.weight(.medium))
                    .foregroundStyle(KhedmaTheme.muted)
                }
            }

            FlowTagRow(tags: KhedmaCopy.providerTags(provider, language: preferences.language))

            Divider().overlay(KhedmaTheme.line.opacity(0.7))

            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(preferences.language.copy(fr: "À partir de", ar: "ابتداءً من"))
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(KhedmaTheme.muted)
                    Text(preferences.language.copy(fr: "\(provider.startingPrice) MAD", ar: "\(provider.startingPrice) درهم"))
                        .font(.headline.weight(.bold))
                        .foregroundStyle(KhedmaTheme.ink)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text(preferences.language.copy(fr: "Prochain créneau", ar: "أقرب موعد"))
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(KhedmaTheme.muted)
                    Text(nextSlotText)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(KhedmaTheme.accentDeep)
                }
            }

            HStack(spacing: 8) {
                Text(preferences.language.copy(fr: "ID + portfolio vérifiés", ar: "هوية وأعمال موثقة"))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(KhedmaTheme.success)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(KhedmaTheme.success.opacity(0.10))
                    .clipShape(Capsule())
                ForEach(provider.badges) { badge in
                    Text(KhedmaCopy.providerBadge(badge, language: preferences.language))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(KhedmaTheme.accentDeep)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 6)
                        .background(KhedmaTheme.accent.opacity(0.11))
                        .clipShape(Capsule())
                }
                Spacer()
            }
        }
        .khedmaCard(padding: 15)
    }

    private var nextSlotText: String {
        guard let slot = provider.availability.first else {
            return preferences.language.copy(fr: "sur demande", ar: "حسب الطلب")
        }
        return "\(KhedmaCopy.availabilityLabel(slot.label, language: preferences.language)) \(slot.time)"
    }
}

struct FlowTagRow: View {
    let tags: [String]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(tags.prefix(3), id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(KhedmaTheme.surfaceWarm.opacity(0.82))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(.white.opacity(0.7), lineWidth: 1))
            }
        }
    }
}

struct DepartmentCard: View {
    @EnvironmentObject private var preferences: AppPreferences
    let department: Department

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if department.status == .active {
                Image("ServiceBeautyHome")
                    .resizable()
                    .scaledToFill()
                LinearGradient(
                    colors: [.black.opacity(0.10), .black.opacity(0.68)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                VisualGradientBackground(palette: .sand)
                    .opacity(0.54)
                LinearGradient(
                    colors: [KhedmaTheme.ink.opacity(0.10), KhedmaTheme.ink.opacity(0.36)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: department.symbol)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 46, height: 46)
                        .background(.white.opacity(0.20))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    Spacer()
                    Text(department.status == .active ? preferences.language.copy(fr: "ACTIF", ar: "متاح") : preferences.language.copy(fr: "BIENTÔT", ar: "قريبًا"))
                        .font(.caption2.weight(.black))
                        .foregroundStyle(.white.opacity(0.92))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.18))
                        .clipShape(Capsule())
                }

                Spacer()

                VStack(alignment: .leading, spacing: 5) {
                    Text(KhedmaCopy.departmentTitle(department, language: preferences.language))
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    Text(KhedmaCopy.departmentSubtitle(department, language: preferences.language))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.78))
                }
            }
            .padding(16)
        }
        .frame(width: 178, height: 184, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.35), lineWidth: 1)
        )
        .shadow(color: KhedmaTheme.ink.opacity(department.status == .active ? 0.14 : 0.06), radius: 18, x: 0, y: 11)
    }
}

struct ServicePhotoCard: View {
    @EnvironmentObject private var preferences: AppPreferences
    let category: BeautyCategory

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(KhedmaCopy.serviceImageAsset(for: category.specialty))
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .clipped()
            LinearGradient(
                colors: [.black.opacity(0.03), .black.opacity(0.62)],
                startPoint: .top,
                endPoint: .bottom
            )
            VStack(alignment: .leading, spacing: 9) {
                HStack {
                    Image(systemName: category.symbol)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 38, height: 38)
                        .background(.white.opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    Spacer()
                    Text(preferences.language.copy(fr: "à domicile", ar: "في المنزل"))
                        .font(.caption2.weight(.black))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.16))
                        .clipShape(Capsule())
                }
                Spacer()
                Text(KhedmaCopy.categoryName(category, language: preferences.language))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                Text(preferences.language.copy(fr: "Sélection vérifiée", ar: "اختيار موثوق"))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.78))
            }
            .padding(14)
        }
        .frame(height: 156)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.38), lineWidth: 1)
        )
        .shadow(color: KhedmaTheme.ink.opacity(0.12), radius: 18, x: 0, y: 12)
    }
}

struct BookingStatusPill: View {
    @EnvironmentObject private var preferences: AppPreferences
    let status: BookingStatus

    var body: some View {
        Text(KhedmaCopy.bookingStatus(status, language: preferences.language))
            .font(.caption.weight(.bold))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }

    private var color: Color {
        switch status {
        case .upcoming: KhedmaTheme.success
        case .past: KhedmaTheme.olive
        case .cancelled: KhedmaTheme.muted
        }
    }
}

struct SkeletonProviderCard: View {
    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 20)
                .fill(KhedmaTheme.line.opacity(0.55))
                .frame(width: 72, height: 72)
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(KhedmaTheme.line.opacity(0.7))
                    .frame(width: 180, height: 14)
                RoundedRectangle(cornerRadius: 6)
                    .fill(KhedmaTheme.line.opacity(0.55))
                    .frame(width: 240, height: 12)
                RoundedRectangle(cornerRadius: 6)
                    .fill(KhedmaTheme.line.opacity(0.45))
                    .frame(width: 140, height: 12)
            }
        }
        .khedmaCard()
        .redacted(reason: .placeholder)
    }
}

struct EmptyComingSoonView: View {
    let title: String
    let detail: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(KhedmaTheme.accentDeep)
                .frame(width: 82, height: 82)
                .background(VisualGradientBackground(palette: .sand))
                .clipShape(Circle())
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(KhedmaTheme.ink)
            Text(detail)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(KhedmaTheme.muted)
        }
        .frame(maxWidth: .infinity)
        .khedmaCard(padding: 26)
    }
}

struct WhatsAppOperatorBubble: View {
    @EnvironmentObject private var preferences: AppPreferences

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(KhedmaTheme.success)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 5) {
                Text(preferences.language.copy(fr: "Coordinatrice Khedma", ar: "منسقة خدمة"))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(KhedmaTheme.success)
                Text(preferences.language.copy(fr: "Votre demande est suivie. L’équipe reste disponible jusqu’à la fin du service.", ar: "طلبك تحت المتابعة. يبقى الفريق متاحًا إلى نهاية الخدمة."))
                    .font(.subheadline)
                    .foregroundStyle(KhedmaTheme.ink)
            }
            Spacer()
        }
        .padding(15)
        .background(
            LinearGradient(colors: [Color(hex: 0xE8F4ED), Color(hex: 0xF7FBF8)], startPoint: .leading, endPoint: .trailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(KhedmaTheme.success.opacity(0.14), lineWidth: 1)
        )
    }
}

struct VisualGradientBackground: View {
    let palette: PortfolioPalette

    var body: some View {
        ZStack {
            LinearGradient(colors: paletteColors(for: palette), startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle()
                .fill(.white.opacity(0.08))
                .frame(width: 120, height: 120)
                .blur(radius: 6)
                .offset(x: -54, y: -52)
            Circle()
                .stroke(.white.opacity(0.06), lineWidth: 16)
                .frame(width: 150, height: 150)
                .offset(x: 70, y: -38)
            MoroccanPattern()
                .stroke(.white.opacity(0.035), lineWidth: 1)
                .frame(width: 180, height: 180)
                .rotationEffect(.degrees(18))
                .offset(x: 48, y: 54)
        }
    }
}

struct VisualAccentRibbon: View {
    let palette: PortfolioPalette

    var body: some View {
        VisualGradientBackground(palette: palette)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .rotationEffect(.degrees(-8))
    }
}

struct PremiumHeroCard<Content: View>: View {
    let palette: PortfolioPalette
    private let content: Content

    init(palette: PortfolioPalette, @ViewBuilder content: () -> Content) {
        self.palette = palette
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VisualGradientBackground(palette: palette)
            content
                .padding(22)
        }
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(.white.opacity(0.34), lineWidth: 1)
        )
        .shadow(color: KhedmaTheme.ink.opacity(0.18), radius: 30, x: 0, y: 18)
    }
}

struct PremiumMetricTile: View {
    let value: String
    let label: String
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: symbol)
                .font(.caption.weight(.bold))
                .foregroundStyle(KhedmaTheme.accentDeep)
            Text(value)
                .font(.title3.weight(.semibold))
                .foregroundStyle(KhedmaTheme.ink)
                .minimumScaleFactor(0.72)
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(KhedmaTheme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(KhedmaTheme.surface.opacity(0.78))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(.white.opacity(0.66), lineWidth: 1))
    }
}

struct PremiumSelectableCard: View {
    let title: String
    let subtitle: String
    let symbol: String
    let palette: PortfolioPalette
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                VisualGradientBackground(palette: palette)
                Image(systemName: symbol)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 58, height: 58)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.title3.weight(.semibold))
                .foregroundStyle(isSelected ? KhedmaTheme.success : KhedmaTheme.line)
        }
        .padding(15)
        .background(isSelected ? KhedmaTheme.accent.opacity(0.10) : KhedmaTheme.surface.opacity(0.82))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(isSelected ? KhedmaTheme.accent.opacity(0.55) : .white.opacity(0.65), lineWidth: 1)
        )
        .shadow(color: isSelected ? KhedmaTheme.accent.opacity(0.13) : KhedmaTheme.ink.opacity(0.05), radius: 18, x: 0, y: 10)
    }
}

struct ModernSearchBar: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(KhedmaTheme.accentDeep)
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .font(.subheadline.weight(.medium))
            Image(systemName: "slider.horizontal.3")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(KhedmaTheme.muted)
        }
        .padding(16)
        .background(KhedmaTheme.surface.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.78), lineWidth: 1)
        )
        .shadow(color: KhedmaTheme.ink.opacity(0.07), radius: 18, x: 0, y: 12)
    }
}

func paletteColors(for palette: PortfolioPalette) -> [Color] {
    switch palette {
    case .rose:
        [Color(hex: 0xC98A98), Color(hex: 0x7B3854)]
    case .olive:
        [Color(hex: 0xAAB38F), Color(hex: 0x566B57)]
    case .clay:
        [Color(hex: 0xC48A72), Color(hex: 0x805245)]
    case .ink:
        [Color(hex: 0x6F6670), Color(hex: 0x211B20)]
    case .gold:
        [Color(hex: 0xD7B66D), Color(hex: 0xA8752E), Color(hex: 0x634532)]
    case .ocean:
        [Color(hex: 0x86A9A8), Color(hex: 0x426B70), Color(hex: 0x243D42)]
    case .sand:
        [Color(hex: 0xE3D0BA), Color(hex: 0xBA8467), Color(hex: 0x796151)]
    }
}
