import WidgetKit
import SwiftUI

struct TrayEntry: TimelineEntry {
    let date: Date
    let isRunning: Bool
    let elapsed: TimeInterval
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TrayEntry {
        TrayEntry(date: Date(), isRunning: false, elapsed: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TrayEntry) -> ()) {
        let entry = TrayEntry(date: Date(), isRunning: false, elapsed: 0)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TrayEntry>) -> ()) {
        let entry = TrayEntry(date: Date(), isRunning: false, elapsed: 0)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct TrayTimerWidgetEntryView : View {
    var entry: TrayEntry
    
    var body: some View {
        VStack {
            Text(entry.isRunning ? "Tray In" : "Tray Out")
            Text(format(seconds: Int(entry.elapsed)))
                .font(.system(.title2, design: .monospaced))
        }
    }
    
    func format(seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        return String(format: "%02d:%02d", h, m)
    }
}

@main
struct TrayTimerWidget: Widget {
    let kind: String = "TrayTimerWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TrayTimerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Tray Timer")
        .description("Track your tray wear time.")
        .supportedFamilies([.systemSmall, .accessoryCircular, .accessoryInline])
    }
}
