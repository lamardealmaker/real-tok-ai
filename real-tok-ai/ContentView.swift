//
//  ContentView.swift
//  real-tok-ai
//
//  Created by Learn on 3/02/25.
//

import SwiftUI

// MARK: - Main Content View
struct ContentView: View {
    // Following Rule: Use @State only for local state managed by view itself
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Main Feed View
            VideoFeedView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            // Placeholder tabs for complete UI
            Text("Discover")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Discover")
                }
                .tag(1)
            
            Text("Create")
                .tabItem {
                    Image(systemName: "plus.square")
                    Text("Create")
                }
                .tag(2)
            
            Text("Inbox")
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Inbox")
                }
                .tag(3)
            
            Text("Profile")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.white)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Video Feed View
struct VideoFeedView: View {
    @State private var isLiked = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Video Background with Gradient Overlay
                Color.black.edgesIgnoringSafeArea(.all)
                
                // Mock Video Content
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1512917774080-9991f1c4c750")) { phase in
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
                        // User Info and Caption
                        VStack(alignment: .leading, spacing: 8) {
                            Text("@lamardealmaker")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("Check out this awesome TikTok clone! #SwiftUI #real-tok-ai")
                                .font(.subheadline)
                                .lineLimit(2)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Action Buttons
                        VStack(spacing: 20) {
                            ActionButton(icon: "heart.fill", count: "1.2M", isActive: isLiked) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    isLiked.toggle()
                                }
                            }
                            ActionButton(icon: "message.fill", count: "4.2K")
                            ActionButton(icon: "square.and.arrow.up", count: "Share")
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
}

// MARK: - Action Button Component
struct ActionButton: View {
    let icon: String
    let count: String
    var isActive: Bool = false
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { action?() }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 35, weight: .semibold))
                    .foregroundColor(isActive ? .red : .white)
                    .shadow(radius: 5)
                Text(count)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
