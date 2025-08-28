import SwiftUI

struct TrackerView: View {
    @EnvironmentObject var timer: WearTimerModel
    @State private var currentTray: Int = 1
    
    var body: some View {
        VStack(spacing: 20) {
            Text(timer.isRunning ? "Tray In" : "Tray Out")
                .font(.title)
            
            Text(timer.elapsedTimeString)
                .font(.system(size: 48, weight: .bold, design: .monospaced))
            
            Button(action: { timer.toggle(tray: currentTray) }) {
                Text(timer.isRunning ? "Stop" : "Start")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(timer.isRunning ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Picker("Tray", selection: $currentTray) {
                ForEach(1..<51) { tray in
                    Text("Tray \(tray)").tag(tray)
                }
            }
            .pickerStyle(.menu)
            
            ProgressView(value: timer.todayWear / timer.dailyGoal) {
                Text("Today's Wear: \(timer.formattedTodayWear)")
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Averages")
                    .font(.headline)
                Text("This Week: \(timer.formattedWeeklyAverage)")
                Text("Current Tray: \(timer.formattedTrayAverage(tray: currentTray))")
                Text("All Time: \(timer.formattedAllTimeAverage)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding()
    }
}

struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView()
            .environmentObject(WearTimerModel())
    }
}
