import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum KhedmaTheme {
    static let background = Color(hex: 0xF6F0E7)
    static let backgroundDeep = Color(hex: 0xE8DACA)
    static let surface = Color.white
    static let surfaceWarm = Color(hex: 0xEFE1D2)
    static let glass = Color.white.opacity(0.64)
    static let accent = Color(hex: 0x9E566B)
    static let accentDeep = Color(hex: 0x4A1F36)
    static let merlot = Color(hex: 0x6B2D4A)
    static let olive = Color(hex: 0x6E806B)
    static let clay = Color(hex: 0xA86F58)
    static let gold = Color(hex: 0xB78A45)
    static let ocean = Color(hex: 0x426B70)
    static let ink = Color(hex: 0x211B20)
    static let muted = Color(hex: 0x746B62)
    static let line = Color(hex: 0xDDD0C2)
    static let success = Color(hex: 0x2F765F)
    static let warning = Color(hex: 0xA8752E)

    static let cardRadius: CGFloat = 22
    static let smallRadius: CGFloat = 14

    static let heroGradient = [Color(hex: 0x211B20), Color(hex: 0x4A1F36), Color(hex: 0xA86F58)]
    static let warmGradient = [Color(hex: 0xFFF8EF), Color(hex: 0xEFE1D2)]
}

enum KhedmaFont {
    static func hero(_ size: CGFloat = 30) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }

    static func title(_ size: CGFloat = 24) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }

    static let section = Font.title3.weight(.semibold)
    static let body = Font.subheadline.weight(.medium)
    static let label = Font.caption.weight(.semibold)
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

extension View {
    func khedmaCard(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: KhedmaTheme.cardRadius, style: .continuous)
                    .fill(KhedmaTheme.surface.opacity(0.92))
            )
            .clipShape(RoundedRectangle(cornerRadius: KhedmaTheme.cardRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: KhedmaTheme.cardRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.9), KhedmaTheme.line.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: KhedmaTheme.ink.opacity(0.045), radius: 14, x: 0, y: 8)
    }

    func premiumSurface(cornerRadius: CGFloat = KhedmaTheme.cardRadius) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(KhedmaTheme.surface.opacity(0.94))
                    .shadow(color: KhedmaTheme.ink.opacity(0.045), radius: 14, x: 0, y: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.white.opacity(0.7), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    func subtlePressScale() -> some View {
        buttonStyle(SoftPressButtonStyle())
    }
}

struct KhedmaBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [KhedmaTheme.background, Color(hex: 0xEFE5DA)], startPoint: .top, endPoint: .bottom)
            Circle()
                .fill(KhedmaTheme.accent.opacity(0.045))
                .frame(width: 240, height: 240)
                .blur(radius: 50)
                .offset(x: -150, y: -260)
            Circle()
                .fill(KhedmaTheme.ocean.opacity(0.035))
                .frame(width: 220, height: 220)
                .blur(radius: 55)
                .offset(x: 170, y: 90)
            MoroccanPattern()
                .stroke(KhedmaTheme.ink.opacity(0.010), lineWidth: 1)
                .frame(width: 360, height: 360)
                .rotationEffect(.degrees(18))
                .offset(x: 150, y: -140)
        }
        .ignoresSafeArea()
    }
}

struct MoroccanPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let columns = 5
        let rows = 5
        let cellWidth = rect.width / CGFloat(columns)
        let cellHeight = rect.height / CGFloat(rows)

        for row in 0..<rows {
            for column in 0..<columns {
                let center = CGPoint(
                    x: rect.minX + CGFloat(column) * cellWidth + cellWidth / 2,
                    y: rect.minY + CGFloat(row) * cellHeight + cellHeight / 2
                )
                let radius = min(cellWidth, cellHeight) * 0.34
                path.move(to: CGPoint(x: center.x, y: center.y - radius))
                path.addQuadCurve(to: CGPoint(x: center.x + radius, y: center.y), control: CGPoint(x: center.x + radius, y: center.y - radius))
                path.addQuadCurve(to: CGPoint(x: center.x, y: center.y + radius), control: CGPoint(x: center.x + radius, y: center.y + radius))
                path.addQuadCurve(to: CGPoint(x: center.x - radius, y: center.y), control: CGPoint(x: center.x - radius, y: center.y + radius))
                path.addQuadCurve(to: CGPoint(x: center.x, y: center.y - radius), control: CGPoint(x: center.x - radius, y: center.y - radius))
            }
        }
        return path
    }
}

struct SoftPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.22, dampingFraction: 0.82), value: configuration.isPressed)
    }
}

@MainActor
func triggerSoftHaptic() {
#if canImport(UIKit)
    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
#endif
}
