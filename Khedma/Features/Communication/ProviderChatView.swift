import SwiftUI

struct ProviderChatView: View {
    @EnvironmentObject private var preferences: AppPreferences
    let provider: Provider
    @State private var draft = ""

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    safetyHeader
                    messageList
                    quickReplies
                }
                .padding(20)
                .padding(.bottom, 12)
            }
            composer
        }
        .background(KhedmaBackground())
        .navigationTitle(preferences.language.copy(fr: "Messages", ar: "الرسائل"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var safetyHeader: some View {
        HStack(alignment: .top, spacing: 13) {
            ProviderAvatarView(provider: provider, size: 58)
            VStack(alignment: .leading, spacing: 6) {
                TrustPill(
                    text: preferences.language.copy(fr: "Conversation suivie", ar: "محادثة متابعة"),
                    symbol: "checkmark.shield.fill",
                    tint: KhedmaTheme.success
                )
                Text(KhedmaCopy.providerName(provider, language: preferences.language))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(preferences.language.copy(fr: "Messages ouverts après réservation. Khedma peut intervenir pour l’adresse, le retard ou la sécurité.", ar: "تُفتح الرسائل بعد الحجز. يمكن لخدمة التدخل للعنوان، التأخير، أو السلامة."))
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .khedmaCard()
    }

    private var messageList: some View {
        VStack(spacing: 12) {
            ForEach(MockData.chatMessages) { message in
                ChatBubble(message: message, provider: provider)
            }
        }
    }

    private var quickReplies: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: preferences.language.copy(fr: "Réponses rapides", ar: "ردود سريعة"))
            FlowTagRow(tags: [
                preferences.language.copy(fr: "Adresse confirmée", ar: "العنوان مؤكد"),
                preferences.language.copy(fr: "Je préfère naturel", ar: "أفضل لمسة طبيعية"),
                preferences.language.copy(fr: "Appeler la coordinatrice", ar: "اتصال بالمنسقة")
            ])
            .khedmaCard()
        }
    }

    private var composer: some View {
        VStack(spacing: 0) {
            Divider().overlay(KhedmaTheme.line)
            HStack(spacing: 10) {
                TextField(preferences.language.copy(fr: "Écrire un message sécurisé...", ar: "اكتبي رسالة آمنة..."), text: $draft)
                    .font(.subheadline)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(KhedmaTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                Button(action: triggerSoftHaptic) {
                    Image(systemName: "arrow.up")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(KhedmaTheme.accentDeep)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
        }
    }
}

private struct ChatBubble: View {
    @EnvironmentObject private var preferences: AppPreferences
    let message: ChatMessage
    let provider: Provider

    var body: some View {
        HStack(alignment: .bottom) {
            if isCurrentUser { Spacer(minLength: 42) }
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 5) {
                    Text(senderName)
                        .font(.caption2.weight(.black))
                        .foregroundStyle(senderColor)
                    Text(message.time)
                        .font(.caption2)
                        .foregroundStyle(KhedmaTheme.muted)
                }
                Text(KhedmaCopy.chatText(message, language: preferences.language))
                    .font(.subheadline)
                    .foregroundStyle(isCurrentUser ? .white : KhedmaTheme.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(13)
            .background(isCurrentUser ? KhedmaTheme.accentDeep : KhedmaTheme.surface.opacity(0.88))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isCurrentUser ? .white.opacity(0.18) : KhedmaTheme.line.opacity(0.7), lineWidth: 1)
            )
            .frame(maxWidth: 292, alignment: isCurrentUser ? .trailing : .leading)
            if !isCurrentUser { Spacer(minLength: 42) }
        }
    }

    private var isCurrentUser: Bool {
        message.sender == .customer
    }

    private var senderColor: Color {
        switch message.sender {
        case .customer: .white.opacity(0.82)
        case .provider: KhedmaTheme.accentDeep
        case .coordinator: KhedmaTheme.success
        }
    }

    private var senderName: String {
        switch message.sender {
        case .customer:
            return preferences.language.copy(fr: "Vous", ar: "أنتِ")
        case .provider:
            return KhedmaCopy.providerName(provider, language: preferences.language)
        case .coordinator:
            return preferences.language.copy(fr: "Khedma", ar: "خدمة")
        }
    }
}

#Preview("Chat") {
    NavigationStack {
        ProviderChatView(provider: MockData.providers[0])
    }
    .khedmaPreviewEnvironment()
}
