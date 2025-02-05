import SwiftUI
import UIKit
import AVKit
import FirebaseCore

// MARK: - Network Manager
@Observable final class NetworkManager {
    // Debug log
    static let shared = NetworkManager()
    
    func likeProperty(uid: String, listingId: String) async throws -> Bool {
        // Debug log
        print("Liking property: \(listingId) for user: \(uid)")
        
        // TODO: Replace with actual API endpoint
        let url = URL(string: "https://api.example.com/like")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "uid": uid,
            "listingId": listingId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // Simulate API call for now
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return true
    }
    
    func favoriteProperty(uid: String, listingId: String) async throws -> Bool {
        // Debug log
        print("Favoriting property: \(listingId) for user: \(uid)")
        
        // TODO: Replace with actual API endpoint
        let url = URL(string: "https://api.example.com/favorite")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "uid": uid,
            "listingId": listingId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // Simulate API call for now
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return true
    }
    
    func unfavoriteProperty(uid: String, listingId: String) async throws -> Bool {
        // Debug log
        print("Unfavoriting property: \(listingId) for user: \(uid)")
        
        // TODO: Replace with actual API endpoint
        let url = URL(string: "https://api.example.com/favorite")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "uid": uid,
            "listingId": listingId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // Simulate API call for now
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return true
    }
    
    func getFavorites(uid: String) async throws -> [Property] {
        // Debug log
        print("Fetching favorites for user: \(uid)")
        
        // TODO: Replace with actual API endpoint
        let url = URL(string: "https://api.example.com/favorites/\(uid)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Simulate API call for now
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Return mock data
        return [
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
                videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                status: "Active",
                listingDate: Date(),
                agent: Agent(name: "Jane Smith", brokerage: "ABC Realty"),
                likeCount: 0,
                isFavorited: true
            )
        ]
    }
}

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
    let videoURL: String
    let status: String
    let listingDate: Date
    let agent: Agent
    var likeCount: Int
    var isFavorited: Bool
    
    // Debug log
    func logPropertyDetails() {
        print("Loading property: \(id)")
        print("Address: \(address.street), \(address.city)")
        print("Price: $\(price)")
        print("Favorited: \(isFavorited)")
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

// MARK: - Share Sheet Helper
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    // Debug log
    init(items: [Any]) {
        print("Initializing ShareSheet with \(items.count) items")
        self.items = items
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        // Debug log
        print("Creating UIActivityViewController")
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Exclude certain activity types that might cause issues
        controller.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .openInIBooks,
            .saveToCameraRoll
        ]
        
        // Handle iPad presentation
        if let popoverController = controller.popoverPresentationController {
            popoverController.permittedArrowDirections = []
            popoverController.sourceView = UIView() // Empty view
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        // Add completion handler for debugging
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if let error = error {
                print("Share error: \(error.localizedDescription)")
                return
            }
            
            if completed {
                print("Share completed via \(activityType?.rawValue ?? "unknown")")
            } else {
                print("Share cancelled")
            }
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Property View Model
@Observable final class PropertyViewModel {
    private(set) var properties: [Property] = []
    private(set) var isShowingShareSheet = false
    // Debug log
    func loadProperties() {
        print("Loading properties from backend...")
        // Simulate loading three dummy properties with video URLs
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
                videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                status: "Active",
                listingDate: Date(),
                agent: Agent(name: "Jane Smith", brokerage: "ABC Realty"),
                likeCount: 0,
                isFavorited: false
            ),
            Property(
                id: "TX-789012",
                address: Address(street: "567 Congress Ave", city: "Austin", state: "TX", zip: "78701"),
                price: 1250000,
                propertyType: "Modern Condo",
                bedrooms: 3,
                bathrooms: 2,
                squareFeet: 2100,
                description: "Ultra-modern downtown condo with stunning city views and designer finishes.",
                features: ["Floor-to-Ceiling Windows", "Private Terrace", "Concierge Service"],
                photos: ["https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=1600&h=900"],
                videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
                status: "Active",
                listingDate: Date(),
                agent: Agent(name: "Michael Chen", brokerage: "Downtown Realty Group"),
                likeCount: 0,
                isFavorited: false
            ),
            Property(
                id: "TX-345678",
                address: Address(street: "890 Travis Heights Blvd", city: "Austin", state: "TX", zip: "78704"),
                price: 1850000,
                propertyType: "Contemporary Home",
                bedrooms: 4,
                bathrooms: 3,
                squareFeet: 3200,
                description: "Beautifully renovated home in Travis Heights featuring a chef's kitchen and a stunning backyard oasis.",
                features: ["Chef's Kitchen", "Pool", "Covered Patio"],
                photos: ["https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?w=1600&h=900"],
                videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
                status: "Active",
                listingDate: Date(),
                agent: Agent(name: "Emily Rodriguez", brokerage: "Austin Elite Properties"),
                likeCount: 0,
                isFavorited: false
            )
        ]
    }
    
    @MainActor
    func likeProperty() async {
        guard let property = properties.first else { return }
        do {
            let uid = "user123"
            let success = try await NetworkManager.shared.likeProperty(uid: uid, listingId: property.id)
            if success, let index = properties.firstIndex(where: { $0.id == property.id }) {
                properties[index].likeCount += 1
                print("Successfully liked property. New like count: \(properties[index].likeCount)")
            }
        } catch {
            print("Error liking property: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func toggleFavorite() async {
        guard let property = properties.first else { return }
        do {
            let uid = "user123"
            let success: Bool
            if property.isFavorited {
                success = try await NetworkManager.shared.unfavoriteProperty(uid: uid, listingId: property.id)
            } else {
                success = try await NetworkManager.shared.favoriteProperty(uid: uid, listingId: property.id)
            }
            if success, let index = properties.firstIndex(where: { $0.id == property.id }) {
                properties[index].isFavorited.toggle()
                print("Successfully \(properties[index].isFavorited ? "favorited" : "unfavorited") property")
            }
        } catch {
            print("Error toggling favorite: \(error.localizedDescription)")
        }
    }
    
    func getShareItems(for property: Property) -> [Any] {
        print("Preparing share items for property: \(property.id)")
        var items: [Any] = []
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        priceFormatter.locale = Locale(identifier: "en_US")
        let price = priceFormatter.string(from: NSNumber(value: property.price)) ?? "$\(property.price)"
        let description = """
        🏠 Check out this amazing property!
        
        📍 \(property.address.street)
        🏘️ \(property.address.city), \(property.address.state) \(property.address.zip)
        💰 \(price)
        🛏️ \(property.bedrooms) beds | 🚿 \(property.bathrooms) baths
        📐 \(property.squareFeet) sq ft
        
        Powered by Real Tok AI
        """
        items.append(description)
        if let url = URL(string: property.photos[0]) {
            items.append(url)
        }
        return items
    }
    
    func toggleShareSheet() {
        print("Toggling share sheet. Current state: \(isShowingShareSheet)")
        isShowingShareSheet.toggle()
    }
}

// MARK: - Favorites View Model
@Observable final class FavoritesViewModel {
    private(set) var favorites: [Property] = []
    private(set) var isLoading = false
    private(set) var error: Error?
    private(set) var isFavoriting = false
    
    @MainActor
    func loadFavorites() async {
        guard !isLoading else { return }
        print("Loading favorites...")
        isLoading = true
        defer { isLoading = false }
        do {
            let uid = "user123"
            favorites = try await NetworkManager.shared.getFavorites(uid: uid)
            print("Successfully loaded \(favorites.count) favorites")
        } catch {
            self.error = error
            print("Error loading favorites: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func unfavoriteProperty(_ property: Property) async {
        guard !isFavoriting else { return }
        print("Attempting to unfavorite property: \(property.id)")
        isFavoriting = true
        defer { isFavoriting = false }
        do {
            let uid = "user123"
            let success = try await NetworkManager.shared.unfavoriteProperty(uid: uid, listingId: property.id)
            if success {
                favorites.removeAll { $0.id == property.id }
                print("Successfully unfavorited property and removed from list")
            }
        } catch {
            print("Error unfavoriting property: \(error.localizedDescription)")
        }
    }
}

// MARK: - Favorites View
struct FavoritesView: View {
    let model: FavoritesViewModel
    @State private var selectedProperty: Property?
    @State private var showPropertyDetails = false
    
    init() {
        self.model = FavoritesViewModel()
    }
    
    var body: some View {
        NavigationView {
            Group {
                if model.isLoading {
                    ProgressView("Loading favorites...")
                        .scaleEffect(1.5)
                } else if let error = model.error {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.yellow)
                        Text("Error loading favorites")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Button("Try Again") {
                            print("Retrying favorites load")
                            Task {
                                await model.loadFavorites()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                } else if model.favorites.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No Favorites Yet")
                            .font(.headline)
                        Text("Properties you favorite will appear here")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(model.favorites) { property in
                                PropertyCard(property: property) {
                                    print("Unfavorite confirmed for property: \(property.id)")
                                    Task {
                                        await model.unfavoriteProperty(property)
                                    }
                                }
                                .onTapGesture {
                                    selectedProperty = property
                                    showPropertyDetails = true
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
        .sheet(isPresented: $showPropertyDetails) {
            if let property = selectedProperty {
                PropertyDetailsOverlay(property: property, isPresented: $showPropertyDetails)
            }
        }
        .onAppear {
            print("FavoritesView appeared")
            Task {
                await model.loadFavorites()
            }
        }
    }
}

// MARK: - Property Card
struct PropertyCard: View {
    let property: Property
    var onUnfavorite: (() -> Void)?
    @State private var showUnfavoriteConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Property Image with Unfavorite Button Overlay
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: property.photos[0])) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipped()
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 160)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray)
                            )
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 160)
                            .overlay(
                                ProgressView()
                                    .scaleEffect(1.5)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                
                if onUnfavorite != nil {
                    Button {
                        print("Unfavorite button tapped for property: \(property.id)")
                        showUnfavoriteConfirmation = true
                    } label: {
                        Image(systemName: "heart.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(8)
                }
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(12)
            
            // Property Info
            VStack(alignment: .leading, spacing: 4) {
                Text(property.address.street)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("\(property.bedrooms) bed • \(property.bathrooms) bath")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("$\(Int(property.price))")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .alert("Remove from Favorites?", isPresented: $showUnfavoriteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Remove", role: .destructive) {
                onUnfavorite?()
            }
        } message: {
            Text("This property will be removed from your favorites list.")
        }
    }
}

// MARK: - Video Feed View (TikTok‑Style)
struct VideoFeedView: View {
    @State private var selectedIndex: Int = 0
    let model: PropertyViewModel
    
    init() {
        self.model = PropertyViewModel()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Vertical paging using rotation hack
                TabView(selection: $selectedIndex) {
                    ForEach(0..<model.properties.count, id: \.self) { index in
                        // Swapping width and height for correct rotation
                        VideoPlayerContainer(property: model.properties[index])
                            .frame(width: geometry.size.height, height: geometry.size.width)
                            .rotationEffect(.degrees(90))
                            .tag(index)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .rotationEffect(.degrees(-90))
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Overlay: Logo and property info/actions based on current property
                if model.properties.indices.contains(selectedIndex) {
                    let property = model.properties[selectedIndex]
                    VStack {
                        // Top section with logo
                        HStack {
                            Spacer()
                            Text("Real Tok AI")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        Spacer()
                        // Bottom section with property info and action buttons
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(property.address.street)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("\(property.bedrooms) Bed | \(property.bathrooms) Bath | $\(Int(property.price))")
                                    .font(.subheadline)
                                    .lineLimit(2)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 20) {
                                ActionButton(
                                    icon: "heart.fill",
                                    count: "\(property.likeCount)",
                                    isActive: false
                                ) {
                                    Task {
                                        await model.likeProperty()
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
                                    print("Share button tapped")
                                    model.toggleShareSheet()
                                }
                            }
                            .padding(.trailing, 16)
                            .padding(.bottom, 100)
                        }
                    }
                    .padding()
                }
            }
            .sheet(isPresented: .init(
                get: { model.isShowingShareSheet },
                set: { _ in model.toggleShareSheet() }
            )) {
                if model.properties.indices.contains(selectedIndex) {
                    ShareSheet(items: model.getShareItems(for: model.properties[selectedIndex]))
                }
            }
        }
        .onAppear {
            print("VideoFeedView appeared")
            model.loadProperties()
        }
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
            
            // Favorites View
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .tag(1)
            
            // Placeholder tabs for complete UI
            Text("Discover")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Discover")
                }
                .tag(2)
            
            Text("Create")
                .tabItem {
                    Image(systemName: "plus.square")
                    Text("Create")
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
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
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