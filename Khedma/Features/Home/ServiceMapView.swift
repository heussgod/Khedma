import SwiftUI
import MapKit

struct ServicePresenceSummaryCard: View {
    @EnvironmentObject private var preferences: AppPreferences

    var body: some View {
        HStack(spacing: 12) {
            MiniCoverageMap(zones: MockData.coverageZones.prefix(4).map { $0 }, compact: true)
                .frame(width: 92, height: 98)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {
                Text(preferences.language.copy(fr: "Voir les zones actives", ar: "عرض المناطق النشطة"))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(preferences.language.copy(fr: "Maarif, Gauthier, Anfa et CIL avec créneaux suivis.", ar: "المعاريف، غوتيي، أنفا وسي آي إل بمواعيد متابعة."))
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 6) {
                    MapFactPill(value: "6", label: preferences.language.copy(fr: "quartiers", ar: "أحياء"))
                    MapFactPill(value: "18", label: preferences.language.copy(fr: "pros", ar: "مهنيات"))
                }
            }

            Spacer(minLength: 4)
            Image(systemName: preferences.language.isRTL ? "chevron.left" : "chevron.right")
                .font(.caption.weight(.black))
                .foregroundStyle(KhedmaTheme.accentDeep)
        }
        .khedmaCard(padding: 13)
    }
}

private struct MapFactPill: View {
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 4) {
            Text(value)
                .font(.caption.weight(.black))
                .foregroundStyle(KhedmaTheme.ink)
            Text(label)
                .font(.caption2.weight(.bold))
                .foregroundStyle(KhedmaTheme.muted)
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
        .background(KhedmaTheme.surfaceWarm.opacity(0.70))
        .clipShape(Capsule())
    }
}

struct ServiceMapView: View {
    @EnvironmentObject private var preferences: AppPreferences
    @State private var selectedSpecialty: BeautySpecialty?
    @State private var selectedZoneID: String? = MockData.coverageZones.first?.id
    @State private var mapPosition: MapCameraPosition = .region(ServiceMapGeometry.casablancaRegion)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                hero
                serviceFilter
                mapCard
                activeZones
                trustNote
            }
            .padding(20)
            .padding(.bottom, 120)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(KhedmaBackground())
        .navigationTitle(preferences.language.copy(fr: "Carte de service", ar: "خريطة الخدمة"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "map.fill")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 46, height: 46)
                    .background(KhedmaTheme.ocean)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                VStack(alignment: .leading, spacing: 6) {
                    Text(preferences.language.copy(fr: "Couverture vérifiée à Casablanca", ar: "تغطية موثوقة في الدار البيضاء"))
                        .font(KhedmaFont.hero(24))
                        .foregroundStyle(KhedmaTheme.ink)
                    Text(preferences.language.copy(fr: "Quartiers où l’équipe peut confirmer, suivre et résoudre les imprévus.", ar: "أحياء يمكن للفريق فيها التأكيد والمتابعة وحل أي طارئ."))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(KhedmaTheme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }
            HStack(spacing: 8) {
                MapFactPill(value: "\(MockData.coverageZones.count)", label: preferences.language.copy(fr: "zones", ar: "مناطق"))
                MapFactPill(value: "\(MockData.coverageZones.reduce(0) { $0 + $1.providerCount })", label: preferences.language.copy(fr: "pros", ar: "مهنيات"))
                MapFactPill(value: preferences.language.copy(fr: "2-8 h", ar: "2-8 س"), label: preferences.language.copy(fr: "créneaux", ar: "مواعيد"))
            }
        }
        .khedmaCard(padding: 15)
    }

    private var serviceFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button {
                    withAnimation(.snappy) {
                        selectedSpecialty = nil
                        selectedZoneID = MockData.coverageZones.first?.id
                        mapPosition = .region(ServiceMapGeometry.casablancaRegion)
                    }
                } label: {
                    ServiceChip(title: preferences.language.copy(fr: "Tous les services", ar: "كل الخدمات"), isSelected: selectedSpecialty == nil)
                }
                .buttonStyle(.plain)

                ForEach(BeautySpecialty.allCases) { specialty in
                    Button {
                        withAnimation(.snappy) {
                            selectedSpecialty = specialty
                            let zones = MockData.coverageZones.filter { $0.activeServices.contains(specialty) }
                            selectedZoneID = zones.first?.id
                            if let first = zones.first {
                                focus(on: first)
                            }
                        }
                    } label: {
                        ServiceChip(title: KhedmaCopy.specialty(specialty, language: preferences.language), isSelected: selectedSpecialty == specialty)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
    }

    private var mapCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            InteractiveCoverageMap(
                zones: filteredZones,
                selectedZoneID: selectedZoneID,
                mapPosition: $mapPosition
            ) { zone in
                withAnimation(.snappy) {
                    selectedZoneID = zone.id
                    focus(on: zone)
                }
            }
                .frame(height: 360)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(.white.opacity(0.72), lineWidth: 1)
                )

            HStack(spacing: 10) {
                WorkerHeroBadge(title: preferences.language.copy(fr: "quartiers", ar: "أحياء"), value: "\(filteredZones.count)")
                WorkerHeroBadge(title: preferences.language.copy(fr: "pros", ar: "مهنيات"), value: "\(filteredZones.reduce(0) { $0 + $1.providerCount })")
                WorkerHeroBadge(title: preferences.language.copy(fr: "filtre", ar: "الفلتر"), value: selectedSpecialty.map { KhedmaCopy.specialty($0, language: preferences.language) } ?? preferences.language.copy(fr: "Tous", ar: "الكل"))
            }

            if let selectedZone {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundStyle(.white)
                        .frame(width: 38, height: 38)
                        .background(KhedmaTheme.ocean)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 4) {
                        Text(KhedmaCopy.neighborhood(selectedZone.neighborhood, language: preferences.language))
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(KhedmaTheme.ink)
                        Text(preferences.language.copy(fr: "\(selectedZone.providerCount) professionnelles vérifiées · créneaux \(KhedmaCopy.coverageETA(selectedZone.etaRange, language: preferences.language))", ar: "\(selectedZone.providerCount) مهنيات موثقات · مواعيد خلال \(KhedmaCopy.coverageETA(selectedZone.etaRange, language: preferences.language))"))
                            .font(.caption)
                            .foregroundStyle(KhedmaTheme.muted)
                    }
                    Spacer()
                }
                .padding(13)
                .background(KhedmaTheme.surfaceWarm.opacity(0.70))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .onTapGesture {
                    withAnimation(.snappy) {
                        focus(on: selectedZone)
                    }
                }
            }
        }
        .khedmaCard(padding: 14)
    }

    private var activeZones: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(
                title: preferences.language.copy(fr: "Zones actives", ar: "المناطق النشطة"),
                action: preferences.language.copy(fr: "Sélection courte", ar: "اختيار محدود")
            )
            VStack(spacing: 12) {
                ForEach(filteredZones) { zone in
                    Button {
                        withAnimation(.snappy) {
                            selectedZoneID = zone.id
                            focus(on: zone)
                        }
                    } label: {
                        CoverageZoneRow(zone: zone, isSelected: selectedZoneID == zone.id)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var trustNote: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.shield.fill")
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .background(KhedmaTheme.success)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            VStack(alignment: .leading, spacing: 5) {
                Text(preferences.language.copy(fr: "Pas une carte ouverte", ar: "ليست خريطة مفتوحة"))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(preferences.language.copy(fr: "Khedma affiche uniquement les zones où l’équipe peut réellement coordonner, confirmer et suivre le service.", ar: "تعرض خدمة فقط المناطق التي يمكن للفريق فيها التنسيق والتأكيد والمتابعة فعليًا."))
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .khedmaCard()
    }

    private var filteredZones: [CoverageZone] {
        guard let selectedSpecialty else { return MockData.coverageZones }
        return MockData.coverageZones.filter { $0.activeServices.contains(selectedSpecialty) }
    }

    private var selectedZone: CoverageZone? {
        filteredZones.first { $0.id == selectedZoneID } ?? filteredZones.first
    }

    private func focus(on zone: CoverageZone?) {
        guard let zone else {
            mapPosition = .region(ServiceMapGeometry.casablancaRegion)
            return
        }
        mapPosition = .region(ServiceMapGeometry.focusRegion(for: zone))
    }
}

enum ServiceMapGeometry {
    static let casablancaRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.5731, longitude: -7.5898),
        span: MKCoordinateSpan(latitudeDelta: 0.115, longitudeDelta: 0.125)
    )

    static func focusRegion(for zone: CoverageZone) -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate(for: zone),
            span: MKCoordinateSpan(latitudeDelta: 0.036, longitudeDelta: 0.040)
        )
    }

    static func coordinate(for zone: CoverageZone) -> CLLocationCoordinate2D {
        switch zone.id {
        case "maarif": CLLocationCoordinate2D(latitude: 33.5824, longitude: -7.6365)
        case "gauthier": CLLocationCoordinate2D(latitude: 33.5902, longitude: -7.6264)
        case "anfa": CLLocationCoordinate2D(latitude: 33.5980, longitude: -7.6495)
        case "bourgogne": CLLocationCoordinate2D(latitude: 33.5991, longitude: -7.6388)
        case "cil": CLLocationCoordinate2D(latitude: 33.5633, longitude: -7.6590)
        case "californie": CLLocationCoordinate2D(latitude: 33.5345, longitude: -7.6154)
        default: casablancaRegion.center
        }
    }
}

struct InteractiveCoverageMap: View {
    @EnvironmentObject private var preferences: AppPreferences
    let zones: [CoverageZone]
    var selectedZoneID: String?
    @Binding var mapPosition: MapCameraPosition
    var onSelect: (CoverageZone) -> Void

    var body: some View {
        Map(position: $mapPosition, interactionModes: [.pan, .zoom]) {
            ForEach(zones) { zone in
                Annotation(KhedmaCopy.neighborhood(zone.neighborhood, language: preferences.language), coordinate: ServiceMapGeometry.coordinate(for: zone)) {
                    Button {
                        onSelect(zone)
                    } label: {
                        MapCoverageMarker(zone: zone, isSelected: zone.id == selectedZoneID, language: preferences.language)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .mapStyle(.standard(elevation: .flat, pointsOfInterest: .excludingAll, showsTraffic: false))
        .mapControls {
            MapCompass()
            MapScaleView()
        }
        .overlay(alignment: .topLeading) {
            Text(preferences.language.copy(fr: "Carte réelle · Casablanca", ar: "خريطة فعلية · الدار البيضاء"))
                .font(.caption.weight(.black))
                .foregroundStyle(KhedmaTheme.ink)
                .padding(.horizontal, 11)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial, in: Capsule())
                .padding(14)
        }
        .overlay(alignment: .bottomLeading) {
            HStack(spacing: 8) {
                LegendDot(color: KhedmaTheme.ocean, label: preferences.language.copy(fr: "Zone active", ar: "منطقة نشطة"))
                LegendDot(color: KhedmaTheme.accentDeep, label: preferences.language.copy(fr: "Sélection", ar: "اختيار"))
            }
            .padding(14)
        }
    }
}

private struct MapCoverageMarker: View {
    let zone: CoverageZone
    var isSelected: Bool
    let language: KhedmaLanguage

    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill((isSelected ? KhedmaTheme.accentDeep : KhedmaTheme.ocean).opacity(0.18))
                    .frame(width: isSelected ? 58 : 48, height: isSelected ? 58 : 48)
                Circle()
                    .fill(isSelected ? KhedmaTheme.accentDeep : KhedmaTheme.ocean)
                    .frame(width: isSelected ? 34 : 28, height: isSelected ? 34 : 28)
                    .overlay(Circle().stroke(.white, lineWidth: 3))
                Text("\(zone.providerCount)")
                    .font(.caption.weight(.black))
                    .foregroundStyle(.white)
            }
            Text(KhedmaCopy.neighborhood(zone.neighborhood, language: language))
                .font(.caption2.weight(.black))
                .foregroundStyle(KhedmaTheme.ink)
                .lineLimit(1)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(.ultraThinMaterial, in: Capsule())
        }
        .shadow(color: KhedmaTheme.ink.opacity(isSelected ? 0.24 : 0.14), radius: isSelected ? 14 : 10, x: 0, y: 6)
        .scaleEffect(isSelected ? 1.06 : 1.0)
    }
}

struct MiniCoverageMap: View {
    @EnvironmentObject private var preferences: AppPreferences
    let zones: [CoverageZone]
    var compact: Bool
    var selectedZoneID: String? = nil

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [Color(hex: 0xF6EFE6), Color(hex: 0xE8DACB), Color(hex: 0xF8F3EC)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Rectangle()
                    .fill(KhedmaTheme.ocean.opacity(0.16))
                    .frame(height: proxy.size.height * (compact ? 0.18 : 0.16))
                    .frame(maxHeight: .infinity, alignment: .top)
                    .overlay(alignment: .bottom) {
                        Image(systemName: "water.waves")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(KhedmaTheme.ocean.opacity(0.55))
                            .padding(.bottom, compact ? 3 : 8)
                    }
                MoroccanPattern()
                    .stroke(KhedmaTheme.ink.opacity(0.028), lineWidth: 1)
                    .frame(width: proxy.size.width * 1.15, height: proxy.size.height * 0.96)
                    .rotationEffect(.degrees(10))
                    .opacity(compact ? 0.35 : 0.55)
                Path { path in
                    path.move(to: CGPoint(x: proxy.size.width * 0.12, y: proxy.size.height * 0.34))
                    path.addCurve(
                        to: CGPoint(x: proxy.size.width * 0.86, y: proxy.size.height * 0.62),
                        control1: CGPoint(x: proxy.size.width * 0.30, y: proxy.size.height * 0.18),
                        control2: CGPoint(x: proxy.size.width * 0.70, y: proxy.size.height * 0.34)
                    )
                    path.move(to: CGPoint(x: proxy.size.width * 0.25, y: proxy.size.height * 0.78))
                    path.addCurve(
                        to: CGPoint(x: proxy.size.width * 0.74, y: proxy.size.height * 0.22),
                        control1: CGPoint(x: proxy.size.width * 0.44, y: proxy.size.height * 0.76),
                        control2: CGPoint(x: proxy.size.width * 0.58, y: proxy.size.height * 0.34)
                    )
                }
                .stroke(KhedmaTheme.ink.opacity(0.12), style: StrokeStyle(lineWidth: compact ? 2 : 4, lineCap: .round, dash: [7, 8]))

                if !compact {
                    MapAreaLabel(text: preferences.language.copy(fr: "Corniche", ar: "الكورنيش"))
                        .position(x: proxy.size.width * 0.22, y: proxy.size.height * 0.18)
                    MapAreaLabel(text: preferences.language.copy(fr: "Centre", ar: "الوسط"))
                        .position(x: proxy.size.width * 0.54, y: proxy.size.height * 0.29)
                    MapAreaLabel(text: preferences.language.copy(fr: "Sud", ar: "الجنوب"))
                        .position(x: proxy.size.width * 0.76, y: proxy.size.height * 0.84)
                }

                ForEach(zones) { zone in
                    CoveragePin(zone: zone, compact: compact, isSelected: selectedZoneID == zone.id)
                        .position(
                            x: proxy.size.width * zone.mapX,
                            y: proxy.size.height * zone.mapY
                        )
                }

                if !compact {
                    VStack {
                        HStack {
                            Text(preferences.language.copy(fr: "Couverture vérifiée", ar: "تغطية موثوقة"))
                                .font(.caption.weight(.bold))
                                .foregroundStyle(KhedmaTheme.ink)
                                .padding(.horizontal, 11)
                                .padding(.vertical, 8)
                                .background(KhedmaTheme.surface.opacity(0.82))
                                .clipShape(Capsule())
                            Spacer()
                        }
                        Spacer()
                        HStack(spacing: 8) {
                            LegendDot(color: KhedmaTheme.accentDeep, label: preferences.language.copy(fr: "Couvert", ar: "مغطى"))
                            LegendDot(color: KhedmaTheme.ocean, label: preferences.language.copy(fr: "Sélection", ar: "اختيار"))
                            Spacer()
                        }
                    }
                    .padding(14)
                }
            }
        }
    }
}

private struct CoveragePin: View {
    @EnvironmentObject private var preferences: AppPreferences
    let zone: CoverageZone
    var compact: Bool
    var isSelected: Bool

    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill((isSelected ? KhedmaTheme.ocean : (paletteColors(for: zone.palette).first ?? KhedmaTheme.accent)).opacity(isSelected ? 0.28 : 0.22))
                    .frame(width: compact ? 42 : 76, height: compact ? 42 : 76)
                Circle()
                    .fill(isSelected ? KhedmaTheme.ocean : (paletteColors(for: zone.palette).last ?? KhedmaTheme.accentDeep))
                    .frame(width: compact ? 17 : 26, height: compact ? 17 : 26)
                    .overlay(Circle().stroke(.white, lineWidth: compact ? 2 : 3))
                if !compact {
                    Text("\(zone.providerCount)")
                        .font(.caption2.weight(.black))
                        .foregroundStyle(.white)
                }
            }

            if !compact {
                Text(KhedmaCopy.neighborhood(zone.neighborhood, language: preferences.language))
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                    .lineLimit(1)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(KhedmaTheme.surface.opacity(isSelected ? 0.94 : 0.78))
                    .clipShape(Capsule())
            }
        }
        .shadow(color: KhedmaTheme.ink.opacity(isSelected ? 0.20 : 0.12), radius: compact ? 8 : 14, x: 0, y: compact ? 4 : 8)
    }
}

private struct MapAreaLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption2.weight(.bold))
            .foregroundStyle(KhedmaTheme.muted.opacity(0.80))
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(KhedmaTheme.surface.opacity(0.52))
            .clipShape(Capsule())
    }
}

private struct LegendDot: View {
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 7, height: 7)
            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(KhedmaTheme.muted)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(KhedmaTheme.surface.opacity(0.72))
        .clipShape(Capsule())
    }
}

private struct CoverageZoneRow: View {
    @EnvironmentObject private var preferences: AppPreferences
    let zone: CoverageZone
    var isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                VisualGradientBackground(palette: zone.palette)
                Text("\(zone.providerCount)")
                    .font(.headline.weight(.black))
                    .foregroundStyle(.white)
            }
            .frame(width: 56, height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(KhedmaCopy.neighborhood(zone.neighborhood, language: preferences.language))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(KhedmaTheme.ink)
                Text(zone.activeServices.map { KhedmaCopy.specialty($0, language: preferences.language) }.joined(separator: " · "))
                    .font(.caption)
                    .foregroundStyle(KhedmaTheme.muted)
                    .lineLimit(2)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(KhedmaCopy.coverageETA(zone.etaRange, language: preferences.language))
                    .font(.caption.weight(.black))
                    .foregroundStyle(isSelected ? KhedmaTheme.ocean : KhedmaTheme.accentDeep)
                Text(preferences.language.copy(fr: "aujourd’hui", ar: "اليوم"))
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(KhedmaTheme.muted)
            }
        }
        .padding(13)
        .background(isSelected ? KhedmaTheme.ocean.opacity(0.12) : KhedmaTheme.surface.opacity(0.78))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(isSelected ? KhedmaTheme.ocean.opacity(0.40) : .white.opacity(0.68), lineWidth: 1)
        )
        .shadow(color: KhedmaTheme.ink.opacity(0.05), radius: 16, x: 0, y: 9)
    }
}

#Preview("Service Map") {
    NavigationStack {
        ServiceMapView()
    }
    .khedmaPreviewEnvironment()
}
