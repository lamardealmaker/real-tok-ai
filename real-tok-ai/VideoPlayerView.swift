import SwiftUI
import AVKit

// <ai_context> Custom AVPlayer wrapper for video playback using uiView.bounds for correct layout after rotation </ai_context>
struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer
    
    func makeUIView(context: Context) -> PlayerContainerView {
        // Debug log
        print("Creating PlayerContainerView")
        let view = PlayerContainerView(player: player)
        // Disable user interaction to allow TabView gestures to pass through
        view.isUserInteractionEnabled = false
        return view
    }
    
    func updateUIView(_ uiView: PlayerContainerView, context: Context) {
        // Debug log
        print("Updating PlayerContainerView with new player")
        uiView.updatePlayer(player)
    }
}

// Custom UIView subclass to properly handle layout
class PlayerContainerView: UIView {
    private var playerLayer: AVPlayerLayer?
    
    init(player: AVPlayer) {
        super.init(frame: .zero)
        setupView(with: player)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(with player: AVPlayer) {
        // Debug log
        print("Setting up PlayerContainerView with player")
        backgroundColor = .black
        
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        layer.frame = bounds
        self.layer.addSublayer(layer)
        self.playerLayer = layer
        
        // Debug log
        print("Initial bounds: \(bounds)")
    }
    
    func updatePlayer(_ player: AVPlayer) {
        playerLayer?.player = player
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Debug log
        print("Layout updating - new bounds: \(bounds)")
        playerLayer?.frame = bounds
    }
}