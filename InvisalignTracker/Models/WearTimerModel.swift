import Foundation
import Combine

struct WearEntry: Identifiable, Codable {
    let id = UUID()
    let tray: Int
    let start: Date
    let end: Date
    var duration: TimeInterval { end.timeIntervalSince(start) }
}

class WearTimerModel: ObservableObject {
    @Published var isRunning = false
    @Published var elapsed: TimeInterval = 0
    @Published var history: [WearEntry] = []
    @Published var todayWear: TimeInterval = 0
    
    let dailyGoal: TimeInterval = 60 * 60 * 22 // 22 hours
    private let historyKey = "wear_history"
    
    private var startDate: Date?
    private var timer: Timer?
    
    init() {
        load()
        updateTodayWear()
    }
    
    func toggle(tray: Int) {
        isRunning ? stop(tray: tray) : start()
    }
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsed = Date().timeIntervalSince(self.startDate ?? Date())
        }
    }
    
    func stop(tray: Int) {
        guard isRunning else { return }
        isRunning = false
        timer?.invalidate()
        let endDate = Date()
        if let startDate = startDate {
            let entry = WearEntry(tray: tray, start: startDate, end: endDate)
            history.append(entry)
            save()
            updateTodayWear()
        }
        elapsed = 0
        startDate = nil
    }
    
    private func updateTodayWear() {
        let calendar = Calendar.current
        todayWear = history.filter { calendar.isDateInToday($0.start) }
            .reduce(0) { $0 + $1.duration }
    }
    
    var weeklyAverage: TimeInterval {
        let calendar = Calendar.current
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else { return 0 }
        let recent = history.filter { $0.start >= weekAgo }
        let grouped = Dictionary(grouping: recent) { calendar.startOfDay(for: $0.start) }
        let totals = grouped.map { $0.value.reduce(0) { $0 + $1.duration } }
        guard !totals.isEmpty else { return 0 }
        return totals.reduce(0, +) / Double(totals.count)
    }
    
    func trayAverage(tray: Int) -> TimeInterval {
        let entries = history.filter { $0.tray == tray }
        guard !entries.isEmpty else { return 0 }
        let total = entries.reduce(0) { $0 + $1.duration }
        return total / Double(entries.count)
    }
    
    var allTimeAverage: TimeInterval {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: history) { calendar.startOfDay(for: $0.start) }
        let totals = grouped.map { $0.value.reduce(0) { $0 + $1.duration } }
        guard !totals.isEmpty else { return 0 }
        return totals.reduce(0, +) / Double(totals.count)
    }
    
    var elapsedTimeString: String { format(seconds: Int(elapsed)) }
    var formattedTodayWear: String { format(seconds: Int(todayWear)) }
    var formattedWeeklyAverage: String { format(seconds: Int(weeklyAverage)) }
    func formattedTrayAverage(tray: Int) -> String { format(seconds: Int(trayAverage(tray: tray))) }
    var formattedAllTimeAverage: String { format(seconds: Int(allTimeAverage)) }
    
    private func format(seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: historyKey),
              let entries = try? JSONDecoder().decode([WearEntry].self, from: data) else { return }
        history = entries
    }
}
