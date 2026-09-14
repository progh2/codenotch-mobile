import SwiftUI
import WidgetKit

private let appGroupId = "group.com.progh2.codenotchMobile"
private let titleKey = "title"
private let usageKey = "usage"

struct CodenotchUsageEntry: TimelineEntry {
    let date: Date
    let title: String
    let usage: String
}

struct CodenotchUsageProvider: TimelineProvider {
    func placeholder(in context: Context) -> CodenotchUsageEntry {
        CodenotchUsageEntry(date: Date(), title: "Codenotch", usage: "--%")
    }

    func getSnapshot(in context: Context, completion: @escaping (CodenotchUsageEntry) -> Void) {
        completion(currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CodenotchUsageEntry>) -> Void) {
        let timeline = Timeline(entries: [currentEntry()], policy: .never)
        completion(timeline)
    }

    private func currentEntry() -> CodenotchUsageEntry {
        let prefs = UserDefaults(suiteName: appGroupId)
        let title = prefs?.string(forKey: titleKey) ?? ""
        let usage = prefs?.string(forKey: usageKey) ?? ""
        return CodenotchUsageEntry(
            date: Date(),
            title: title.isEmpty ? "Codenotch" : title,
            usage: usage.isEmpty ? "--%" : usage
        )
    }
}

struct CodenotchUsageWidgetView: View {
    var entry: CodenotchUsageEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.title)
                .font(.headline)
                .foregroundColor(.white)
            Text(entry.usage)
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.91, green: 0.75, blue: 0.48))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .codenotchWidgetBackground()
    }
}

extension View {
    @ViewBuilder
    func codenotchWidgetBackground() -> some View {
        let color = Color(red: 0.10, green: 0.10, blue: 0.11)
        if #available(iOSApplicationExtension 17.0, *) {
            containerBackground(for: .widget) { color }
        } else {
            background(color)
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
        .description("Placeholder AI usage widget. Live usage lands later.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct CodenotchUsageWidget_Previews: PreviewProvider {
    static var previews: some View {
        CodenotchUsageWidgetView(
            entry: CodenotchUsageEntry(date: Date(), title: "Codenotch", usage: "--%")
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
