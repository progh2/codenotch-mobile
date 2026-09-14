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

struct CodenotchUsageWidgetView: View {
    var entry: CodenotchUsageEntry

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            ZStack {
                UsageRingView(progress: Double(entry.percent) / 100.0)
                    .padding(side * 0.06)
                VStack(spacing: 4) {
                    Text(entry.percentText)
                        .font(.system(size: side * 0.22, weight: .bold, design: .rounded))
                        .foregroundColor(percentColor)
                    Text(entry.label)
                        .font(.system(size: max(10, side * 0.075), weight: .medium))
                        .foregroundColor(labelColor)
                        .lineLimit(1)
                }
                .offset(y: 3)
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
            UsageRingShape(progress: 1)
                .stroke(ringTrack, style: StrokeStyle(lineWidth: 6, lineCap: .round))
            UsageRingShape(progress: min(max(progress, 0), 1))
                .stroke(ringFill, style: StrokeStyle(lineWidth: 6.9, lineCap: .round))
        }
    }
}

/// 270° horseshoe starting at 135° so the upper arc is the longest curve.
struct UsageRingShape: Shape {
    var progress: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let inset = min(rect.width, rect.height) * 0.08
        let drawRect = rect.insetBy(dx: inset, dy: inset)
        let start = Angle.degrees(135)
        let end = Angle.degrees(135 + 270 * progress)
        path.addArc(
            center: CGPoint(x: drawRect.midX, y: drawRect.midY),
            radius: min(drawRect.width, drawRect.height) / 2,
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
