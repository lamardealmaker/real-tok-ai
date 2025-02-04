import SwiftUI
import FirebaseFirestore

// MARK: - Video Feed View
struct VideoFeedView: View {
    @State private var isLiked = false
    @State private var showPropertyDetails = false
    let model: PropertyViewModel
    
    init() {
        self.model = PropertyViewModel()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Video Background with Gradient Overlay
                Color.black.edgesIgnoringSafeArea(.all)
                
                if let property = model.currentProperty {
                    // Property Content
                    AsyncImage(url: URL(string: property.photos[0])) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                                .overlay(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            .black.opacity(0.3),
                                            .clear,
                                            .black.opacity(0.7)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .onTapGesture {
                                    showPropertyDetails.toggle()
                                }
                        case .failure(let error):
                            VStack {
                                Color.black
                                Text("Error: \(error.localizedDescription)")
                                    .foregroundColor(.white)
                            }
                        case .empty:
                            ProgressView()
                                .scaleEffect(2.0)
                                .tint(.white)
                        @unknown default:
                            Color.black
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                    // Content Overlays
                    VStack(spacing: 0) {
                        // Top Section with Logo
                        HStack {
                            Spacer()
                            Text("Real Tok AI")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 0)
                            Spacer()
                        }
                        
                        Spacer()
                        
                        // Bottom Section
                        HStack(alignment: .bottom, spacing: 0) {
                            // Property Info
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(property.address.street)")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("\(property.bedrooms) Bed | \(property.bathrooms) Bath | $\(Int(property.price))")
                                    .font(.subheadline)
                                    .lineLimit(2)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Action Buttons
                            VStack(spacing: 20) {
                                ActionButton(
                                    icon: "heart.fill",
                                    count: "\(property.likeCount)",
                                    isActive: isLiked
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        isLiked.toggle()
                                        Task {
                                            await model.likeProperty()
                                        }
                                    }
                                }
                                ActionButton(
                                    icon: "bookmark.fill",
                                    count: "Save",
                                    isActive: property.isFavorited
                                ) {
                                    Task {
                                        await model.toggleFavorite()
                                    }
                                }
                                ActionButton(
                                    icon: "square.and.arrow.up",
                                    count: "Share"
                                ) {
                                    // Debug log
                                    print("Share button tapped")
                                    model.toggleShareSheet()
                                }
                            }
                            .padding(.trailing, 16)
                            .padding(.bottom, 100)
                        }
                    }
                    
                    // Property Details Overlay
                    if showPropertyDetails {
                        PropertyDetailsOverlay(property: property, isPresented: $showPropertyDetails)
                            .transition(.opacity)
                    }
                }
            }
        }
        .onAppear {
            // Debug log
            print("VideoFeedView appeared")
            model.loadProperties()
        }
        .sheet(isPresented: .init(
            get: { model.isShowingShareSheet },
            set: { _ in model.toggleShareSheet() }
        )) {
            if let property = model.currentProperty {
                ShareSheet(items: model.getShareItems(for: property))
            }
        }
    }
} 