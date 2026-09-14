import SwiftUI
import WidgetKit

private let appGroupId = "group.com.progh2.codenotchMobile"
private let titleKey = "title"
private let usageKey = "usage"
private let labelKey = "label"
private let percentKey = "percent"

private let widgetBackground = Color(red: 11 / 255, green: 15 / 255, blue: 20 / 255)
private let ringTrack = Color(red: 28 / 255, green: 36 / 255, blue: 48 / 255)
private let ringFill = Color(red: 94 / 255, green: 234 / 255, blue: 212 / 255)
private let percentColor = Color(red: 243 / 255, green: 246 / 255, blue: 250 / 255)
private let labelColor = Color(red: 139 / 255, green: 150 / 255, blue: 168 / 255)

/// Upper-120° highlight: lerp of locked fill → percent (no new hex).
private let highlightMix = 0.25
private let ringFillHighlight = Color(
    red: (94 + (243 - 94) * highlightMix) / 255,
    green: (234 + (246 - 234) * highlightMix) / 255,
    blue: (212 + (250 - 212) * highlightMix) / 255
)

private let startDegrees = 135.0
private let sweepDegrees = 270.0
private let highlightStartDegrees = 210.0
private let highlightSweepDegrees = 120.0
private let strokeWidth = 6.0
private let innerPaddingRatio = 0.12
private let percentHeightRatio = 0.28
private let labelToPercentRatio = 0.40

private let defaultPercent = 72
private let defaultLabel = "Mock usage"

struct CodenotchUsageEntry: TimelineEntry {
    let date: Date
    let title: String
    let percent: Int
    let percentText: String
    let label: String
}

struct CodenotchUsageProvider: TimelineProvider {
    func placeholder(in context: Context) -> CodenotchUsageEntry {
        CodenotchUsageEntry(
            date: Date(),
            title: "Codenotch",
            percent: defaultPercent,
            percentText: "\(defaultPercent)%",
            label: defaultLabel
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (CodenotchUsageEntry) -> Void) {
        completion(currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CodenotchUsageEntry>) -> Void) {
        let next = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
        let timeline = Timeline(entries: [currentEntry()], policy: .after(next))
        completion(timeline)
    }

    private func currentEntry() -> CodenotchUsageEntry {
        let prefs = UserDefaults(suiteName: appGroupId)
        let usage = prefs?.string(forKey: usageKey) ?? ""
        let label = prefs?.string(forKey: labelKey) ?? ""
        let storedPercent = (prefs?.object(forKey: percentKey) as? NSNumber)?.intValue
        let parsed = usage.replacingOccurrences(of: "%", with: "")
        let percent = storedPercent ?? Int(parsed) ?? defaultPercent
        let percentText = usage.isEmpty ? "\(percent)%" : usage
        return CodenotchUsageEntry(
            date: Date(),
            title: {
                let title = prefs?.string(forKey: titleKey) ?? ""
                return title.isEmpty ? "Codenotch" : title
            }(),
            percent: min(max(percent, 0), 100),
            percentText: percentText,
            label: label.isEmpty ? defaultLabel : label
        )
    }
}

func highlightArc(progress: Double) -> (start: Double, sweep: Double)? {
    let fillEnd = startDegrees + sweepDegrees * min(max(progress, 0), 1)
    let overlapStart = max(startDegrees, highlightStartDegrees)
    let overlapEnd = min(fillEnd, highlightStartDegrees + highlightSweepDegrees)
    guard overlapEnd > overlapStart else { return nil }
    return (overlapStart, overlapEnd - overlapStart)
}

struct CodenotchUsageWidgetView: View {
    var entry: CodenotchUsageEntry

    var body: some View {
        GeometryReader { geo in
            let shortSide = min(geo.size.width, geo.size.height)
            let percentSize = geo.size.height * percentHeightRatio
            let labelSize = percentSize * labelToPercentRatio
            ZStack {
                UsageRingView(progress: Double(entry.percent) / 100.0)
                    .padding(shortSide * innerPaddingRatio)
                VStack(spacing: geo.size.height * 0.02) {
                    Text(entry.percentText)
                        .font(.system(size: percentSize, weight: .bold, design: .rounded))
                        .foregroundColor(percentColor)
                    Text(entry.label)
                        .font(.system(size: labelSize, weight: .medium))
                        .foregroundColor(labelColor)
                        .lineLimit(1)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .codenotchWidgetBackground()
    }
}

struct UsageRingView: View {
    var progress: Double

    var body: some View {
        ZStack {
            UsageRingShape(startDegrees: startDegrees, sweepDegrees: sweepDegrees)
                .stroke(ringTrack, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
            UsageRingShape(
                startDegrees: startDegrees,
                sweepDegrees: sweepDegrees * min(max(progress, 0), 1)
            )
            .stroke(ringFill, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
            if let band = highlightArc(progress: progress) {
                UsageRingShape(startDegrees: band.start, sweepDegrees: band.sweep)
                    .stroke(ringFillHighlight, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
            }
        }
    }
}

/// 270° horseshoe starting at 135° so the upper arc is the longest curve.
struct UsageRingShape: Shape {
    var startDegrees: Double
    var sweepDegrees: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard sweepDegrees > 0 else { return path }
        let start = Angle.degrees(startDegrees)
        let end = Angle.degrees(startDegrees + sweepDegrees)
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: min(rect.width, rect.height) / 2,
            startAngle: start,
            endAngle: end,
            clockwise: false
        )
        return path
    }
}

extension View {
    @ViewBuilder
    func codenotchWidgetBackground() -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            containerBackground(for: .widget) { widgetBackground }
        } else {
            background(widgetBackground)
        }
    }
}

@main
struct CodenotchUsageWidget: Widget {
    let kind = "CodenotchUsageWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CodenotchUsageProvider()) { entry in
            CodenotchUsageWidgetView(entry: entry)
        }
        .configurationDisplayName("Codenotch")
        .description("Mock AI usage ring. Live usage lands later.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct CodenotchUsageWidget_Previews: PreviewProvider {
    static var previews: some View {
        CodenotchUsageWidgetView(
            entry: CodenotchUsageEntry(
                date: Date(),
                title: "Codenotch",
                percent: 72,
                percentText: "72%",
                label: "Mock usage"
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
