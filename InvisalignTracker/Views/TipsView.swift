import SwiftUI
import AVKit

struct TipVideo: Identifiable {
    let id = UUID()
    let title: String
    let url: URL
}

struct TipsView: View {
    let videos: [TipVideo] = [
        TipVideo(title: "Cleaning Tips", url: URL(string: "https://example.com/cleaning.mp4")!),
        TipVideo(title: "Switching Trays", url: URL(string: "https://example.com/switching.mp4")!)
    ]
    
    var body: some View {
        NavigationView {
            List(videos) { video in
                VStack(alignment: .leading) {
                    Text(video.title)
                        .font(.headline)
                    VideoPlayer(player: AVPlayer(url: video.url))
                        .frame(height: 200)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Tips")
        }
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
    }
}
