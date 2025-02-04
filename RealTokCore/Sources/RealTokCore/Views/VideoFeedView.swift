import SwiftUI
import AVKit
import UIKit

public struct VideoFeedView: View {
    // Debug log helper
    private static func log(_ message: String) {
        print("[VideoFeedView] \(message)")
    }
    
    // MARK: - Properties
    private let model: PropertyViewModel
    private let userId: String
    
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var showShareSheet = false
    @State private var shareItems: [Any] = []
    
    // MARK: - Initialization
    public init(model: PropertyViewModel, userId: String) {
        self.model = model
        self.userId = userId
        VideoFeedView.log("Initialized VideoFeedView")
    }
    
    // MARK: - Body
    public var body: some View {
        GeometryReader { geometry in
            if let property = model.currentProperty {
                ZStack {
                    // Video Background
                    if let videoURL = URL(string: property.photos[0]) { // Assuming first photo is video URL for now
                        VideoPlayer(player: player)
                            .onAppear {
                                player = AVPlayer(url: videoURL)
                                player?.play()
                                isPlaying = true
                                VideoFeedView.log("Started playing video for property: \(property.id)")
                            }
                            .onDisappear {
                                player?.pause()
                                isPlaying = false
                                VideoFeedView.log("Stopped playing video for property: \(property.id)")
                            }
                    }
                    
                    // Property Content
                    VStack {
                        Spacer()
                        
                        // Property Details
                        VStack(alignment: .leading, spacing: 8) {
                            // Price and Address
                            Text(String(format: "$%.0f", property.price))
                                .font(.title)
                                .bold()
                            
                            Text("\(property.address.street)")
                                .font(.headline)
                            
                            Text("\(property.address.city), \(property.address.state) \(property.address.zip)")
                                .font(.subheadline)
                            
                            // Property Stats
                            HStack(spacing: 16) {
                                Label("\(property.bedrooms)", systemImage: "bed.double")
                                Label(String(format: "%.1f", property.bathrooms), systemImage: "shower")
                                Label("\(property.squareFeet) sqft", systemImage: "ruler")
                            }
                            .font(.subheadline)
                            
                            // Features
                            if !property.features.isEmpty {
                                Text("Features:")
                                    .font(.headline)
                                    .padding(.top, 4)
                                
                                ForEach(property.features, id: \.self) { feature in
                                    Label(feature, systemImage: "checkmark.circle")
                                        .font(.subheadline)
                                }
                            }
                            
                            // Agent Info
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(property.agent.name)
                                        .font(.headline)
                                    Text(property.agent.brokerage)
                                        .font(.subheadline)
                                }
                                Spacer()
                                Button(action: {
                                    // TODO: Add contact agent action
                                    VideoFeedView.log("Contact agent tapped for: \(property.agent.name)")
                                }) {
                                    Text("Contact")
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            .padding(.top, 8)
                        }
                        .padding()
                        .background(
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .cornerRadius(16)
                        )
                        .padding()
                    }
                    
                    // Action Buttons
                    VStack {
                        Spacer()
                        
                        // Like, Favorite, Share buttons
                        HStack(spacing: 24) {
                            // Like Button
                            Button(action: {
                                Task {
                                    await model.likeCurrentProperty()
                                    VideoFeedView.log("Like button tapped")
                                }
                            }) {
                                VStack {
                                    Image(systemName: "heart.fill")
                                        .font(.title)
                                    Text("\(property.likeCount)")
                                        .font(.caption)
                                }
                            }
                            
                            // Favorite Button
                            Button(action: {
                                Task {
                                    await model.toggleFavorite(userId: userId)
                                    VideoFeedView.log("Favorite button tapped")
                                }
                            }) {
                                Image(systemName: property.isFavorited ? "bookmark.fill" : "bookmark")
                                    .font(.title)
                            }
                            
                            // Share Button
                            Button(action: {
                                shareItems = model.prepareShareItems()
                                showShareSheet = true
                                VideoFeedView.log("Share button tapped")
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 16)
                    }
                    .padding(.trailing, 16)
                }
                .edgesIgnoringSafeArea(.all)
                .sheet(isPresented: $showShareSheet) {
                    if #available(iOS 16.0, *) {
                        ShareSheet(items: shareItems)
                            .presentationDetents([.medium, .large])
                    } else {
                        ShareSheet(items: shareItems)
                    }
                }
                // Swipe Gestures
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            let threshold: CGFloat = 50
                            if value.translation.width > threshold {
                                model.previousProperty()
                                VideoFeedView.log("Swiped right to previous property")
                            } else if value.translation.width < -threshold {
                                model.nextProperty()
                                VideoFeedView.log("Swiped left to next property")
                            }
                        }
                )
            } else {
                // No property available
                VStack {
                    Text("No properties available")
                        .font(.title)
                    if model.isLoading {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            await model.loadProperties()
            VideoFeedView.log("Started loading properties")
        }
    }
}

// MARK: - ShareSheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
} 