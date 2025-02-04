import Foundation
import SwiftUI

@Observable
public class PropertyViewModel {
    // Debug log helper
    private static func log(_ message: String) {
        print("[PropertyViewModel] \(message)")
    }
    
    // MARK: - Properties
    private let networkManager: NetworkManager
    
    public var properties: [Property] = []
    public var currentIndex: Int = 0
    public var isLoading = false
    public var error: Error?
    
    // MARK: - Computed Properties
    public var currentProperty: Property? {
        guard !properties.isEmpty, currentIndex >= 0, currentIndex < properties.count else { return nil }
        return properties[currentIndex]
    }
    
    // MARK: - Initialization
    public init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        PropertyViewModel.log("Initialized PropertyViewModel")
    }
    
    // MARK: - Data Loading
    @MainActor
    public func loadProperties() async {
        guard !isLoading else { return }
        
        PropertyViewModel.log("Loading properties...")
        isLoading = true
        error = nil
        
        do {
            properties = try await networkManager.fetchProperties()
            currentIndex = 0
            PropertyViewModel.log("Successfully loaded \(properties.count) properties")
        } catch {
            self.error = error
            PropertyViewModel.log("Error loading properties: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Property Actions
    @MainActor
    public func likeCurrentProperty() async {
        guard let property = currentProperty else { return }
        
        PropertyViewModel.log("Liking property: \(property.id)")
        
        do {
            try await networkManager.likeProperty(property)
            // Update local state if needed
            PropertyViewModel.log("Successfully liked property: \(property.id)")
        } catch {
            self.error = error
            PropertyViewModel.log("Error liking property: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    public func toggleFavorite(userId: String) async {
        guard let property = currentProperty else { return }
        
        PropertyViewModel.log("Toggling favorite for property: \(property.id)")
        
        do {
            if property.isFavorited {
                try await networkManager.unfavoriteProperty(property, userId: userId)
                // Update local state
                if let index = properties.firstIndex(where: { $0.id == property.id }) {
                    properties[index].isFavorited = false
                }
                PropertyViewModel.log("Successfully unfavorited property: \(property.id)")
            } else {
                try await networkManager.favoriteProperty(property, userId: userId)
                // Update local state
                if let index = properties.firstIndex(where: { $0.id == property.id }) {
                    properties[index].isFavorited = true
                }
                PropertyViewModel.log("Successfully favorited property: \(property.id)")
            }
        } catch {
            self.error = error
            PropertyViewModel.log("Error toggling favorite: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    public func loadFavorites(userId: String) async {
        guard !isLoading else { return }
        
        PropertyViewModel.log("Loading favorites for user: \(userId)")
        isLoading = true
        error = nil
        
        do {
            properties = try await networkManager.getFavorites(userId: userId)
            currentIndex = 0
            // Mark all properties as favorited since they're from favorites list
            properties = properties.map { var p = $0; p.isFavorited = true; return p }
            PropertyViewModel.log("Successfully loaded \(properties.count) favorites")
        } catch {
            self.error = error
            PropertyViewModel.log("Error loading favorites: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Navigation
    public func nextProperty() {
        guard !properties.isEmpty else { return }
        currentIndex = (currentIndex + 1) % properties.count
        PropertyViewModel.log("Moved to next property: \(currentIndex + 1)/\(properties.count)")
    }
    
    public func previousProperty() {
        guard !properties.isEmpty else { return }
        currentIndex = currentIndex > 0 ? currentIndex - 1 : properties.count - 1
        PropertyViewModel.log("Moved to previous property: \(currentIndex + 1)/\(properties.count)")
    }
    
    // MARK: - Sharing
    public func prepareShareItems() -> [Any] {
        guard let property = currentProperty else { return [] }
        
        let address = property.address
        let fullAddress = "\(address.street), \(address.city), \(address.state) \(address.zip)"
        let price = String(format: "$%.2f", property.price)
        let shareText = """
        Check out this \(property.propertyType) property!
        
        📍 \(fullAddress)
        💰 \(price)
        🛏 \(property.bedrooms) beds | 🚿 \(property.bathrooms) baths
        📐 \(property.squareFeet) sq ft
        
        Features:
        \(property.features.map { "• \($0)" }.joined(separator: "\n"))
        
        Listed by \(property.agent.name) at \(property.agent.brokerage)
        """
        
        PropertyViewModel.log("Prepared share items for property: \(property.id)")
        return [shareText]
    }
} 