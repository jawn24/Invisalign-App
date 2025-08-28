import SwiftUI

@main
struct InvisalignTrackerApp: App {
    @StateObject private var timerModel = WearTimerModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerModel)
        }
    }
}
