import SwiftUI
import AVKit

// <ai_context> Container for video player that wraps VideoPlayerView and handles playback with sound using property.videoURL </ai_context>
struct VideoPlayerContainer: View {
    let property: Property
    @State private var player: AVPlayer
    
    init(property: Property) {
         self.property = property
         self._player = State(initialValue: AVPlayer(url: URL(string: property.videoURL)!))
    }
    
    var body: some View {
        VideoPlayerView(player: player)
            .onAppear {
                // Start playing the video with sound when the view appears
                player.play()
            }
            .onDisappear {
                // Pause the video when the view disappears
                player.pause()
            }
    }
}