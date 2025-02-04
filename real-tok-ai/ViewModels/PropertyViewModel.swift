import SwiftUI

// MARK: - Property View Model
@Observable final class PropertyViewModel {
    private(set) var properties: [Property] = []
    private(set) var currentIndex: Int = 0
    private(set) var isLiking = false
    private(set) var isFavoriting = false
    private(set) var isShowingShareSheet = false
    
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
                likeCount: 0,
                isFavorited: false
            )
        ]
    }
    
    var currentProperty: Property? {
        guard !properties.isEmpty else { return nil }
        return properties[currentIndex]
    }
    
    // Like functionality
    @MainActor
    func likeProperty() async {
        guard let property = currentProperty else { return }
        guard !isLiking else { return }
        
        // Debug log
        print("Attempting to like property: \(property.id)")
        
        isLiking = true
        defer { isLiking = false }
        
        do {
            // TODO: Get actual user ID from authentication
            let uid = "user123"
            let success = try await NetworkManager.shared.likeProperty(uid: uid, listingId: property.id)
            
            if success {
                // Update local state
                if let index = properties.firstIndex(where: { $0.id == property.id }) {
                    properties[index].likeCount += 1
                    // Debug log
                    print("Successfully liked property. New like count: \(properties[index].likeCount)")
                }
            }
        } catch {
            // Debug log
            print("Error liking property: \(error.localizedDescription)")
            // TODO: Show error to user
        }
    }
    
    // Favorite functionality
    @MainActor
    func toggleFavorite() async {
        guard let property = currentProperty else { return }
        guard !isFavoriting else { return }
        
        // Debug log
        print("Attempting to toggle favorite for property: \(property.id)")
        
        isFavoriting = true
        defer { isFavoriting = false }
        
        do {
            // TODO: Get actual user ID from authentication
            let uid = "user123"
            let success: Bool
            
            if property.isFavorited {
                success = try await NetworkManager.shared.unfavoriteProperty(uid: uid, listingId: property.id)
            } else {
                success = try await NetworkManager.shared.favoriteProperty(uid: uid, listingId: property.id)
            }
            
            if success {
                // Update local state
                if let index = properties.firstIndex(where: { $0.id == property.id }) {
                    properties[index].isFavorited.toggle()
                    // Debug log
                    print("Successfully \(properties[index].isFavorited ? "favorited" : "unfavorited") property")
                }
            }
        } catch {
            // Debug log
            print("Error toggling favorite: \(error.localizedDescription)")
            // TODO: Show error to user
        }
    }
    
    // Share functionality
    func getShareItems(for property: Property) -> [Any] {
        // Debug log
        print("Preparing share items for property: \(property.id)")
        
        var items: [Any] = []
        
        // Add property details
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
        
        // Add first photo if available
        if let url = URL(string: property.photos[0]) {
            items.append(url)
        }
        
        return items
    }
    
    func toggleShareSheet() {
        // Debug log
        print("Toggling share sheet. Current state: \(isShowingShareSheet)")
        isShowingShareSheet.toggle()
    }
} 