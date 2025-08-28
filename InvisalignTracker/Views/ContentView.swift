import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TrackerView()
                .tabItem { Label("Tracker", systemImage: "timer") }
            TipsView()
                .tabItem { Label("Tips", systemImage: "play.rectangle") }
            ProductsView()
                .tabItem { Label("Products", systemImage: "bag") }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WearTimerModel())
    }
}
