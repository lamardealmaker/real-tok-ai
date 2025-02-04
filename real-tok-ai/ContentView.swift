//
//  ContentView.swift
//  real-tok-ai
//
//  Created by Learn on 3/02/25.
//

import SwiftUI

// MARK: - Property Model
struct Property: Identifiable {
    let id: String
    let address: Address
    let price: Double
    let propertyType: String
    let bedrooms: Int
    let bathrooms: Int
    let squareFeet: Int
    let description: String
    let features: [String]
    let photos: [String]
    let status: String
    let listingDate: Date
    let agent: Agent
    var likeCount: Int
    
    // Debug log
    func logPropertyDetails() {
        print("Loading property: \(id)")
        print("Address: \(address.street), \(address.city)")
        print("Price: $\(price)")
    }
}

struct Address {
    let street: String
    let city: String
    let state: String
    let zip: String
}

struct Agent {
    let name: String
    let brokerage: String
}

// MARK: - Property View Model
@Observable final class PropertyViewModel {
    private(set) var properties: [Property] = []
    private(set) var currentIndex: Int = 0
    
    // Debug log
    func loadProperties() {
        print("Loading properties from backend...")
        // TODO: Implement actual API call
        properties = [
            Property(
                id: "TX-123456",
                address: Address(street: "123 Elm St", city: "Austin", state: "TX", zip: "78701"),
                price: 500000,
                propertyType: "Single Family Home",
                bedrooms: 4,
                bathrooms: 3,
                squareFeet: 2500,
                description: "Beautiful updated home in downtown Austin with a modern kitchen and spacious backyard.",
                features: ["Modern Kitchen", "Spacious Backyard", "Swimming Pool"],
                photos: ["https://images.unsplash.com/photo-1512917774080-9991f1c4c750"],
                status: "Active",
                listingDate: Date(),
                agent: Agent(name: "Jane Smith", brokerage: "ABC Realty"),
                likeCount: 0
            )
        ]
    }
    
    var currentProperty: Property? {
        guard !properties.isEmpty else { return nil }
        return properties[currentIndex]
    }
}

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
                                ActionButton(icon: "heart.fill", count: "\(property.likeCount)", isActive: isLiked) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        isLiked.toggle()
                                    }
                                }
                                ActionButton(icon: "message.fill", count: "Info") {
                                    showPropertyDetails.toggle()
                                }
                                ActionButton(icon: "square.and.arrow.up", count: "Share")
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
    }
}

// MARK: - Property Details Overlay
struct PropertyDetailsOverlay: View {
    let property: Property
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.85)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            // Property Details Card
            VStack(alignment: .leading, spacing: 20) {
                // Header with close button
                HStack {
                    Text("Property Details")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                    }
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Main Details
                        Group {
                            Text("\(property.address.street)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("\(property.address.city), \(property.address.state) \(property.address.zip)")
                                .foregroundColor(.gray)
                            
                            Text("$\(Int(property.price))")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        // Property Specs
                        HStack(spacing: 20) {
                            PropertySpec(icon: "bed.double.fill", value: "\(property.bedrooms)", label: "Beds")
                            PropertySpec(icon: "shower.fill", value: "\(property.bathrooms)", label: "Baths")
                            PropertySpec(icon: "square.fill", value: "\(property.squareFeet)", label: "Sq Ft")
                        }
                        
                        // Description
                        Text("Description")
                            .font(.headline)
                        Text(property.description)
                            .foregroundColor(.gray)
                        
                        // Features
                        Text("Features")
                            .font(.headline)
                        ForEach(property.features, id: \.self) { feature in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(feature)
                            }
                        }
                        
                        // Agent Info
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Listed By")
                                .font(.headline)
                            Text("\(property.agent.name)")
                                .fontWeight(.semibold)
                            Text("\(property.agent.brokerage)")
                                .foregroundColor(.gray)
                        }
                        .padding(.top)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
        }
    }
}

// MARK: - Property Spec Component
struct PropertySpec: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
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
