import SwiftUI

// MARK: - Favorites View Model
@Observable final class FavoritesViewModel {
    private(set) var favorites: [Property] = []
    private(set) var isLoading = false
    private(set) var error: Error?
    private(set) var isFavoriting = false
    
    @MainActor
    func loadFavorites() async {
        guard !isLoading else { return }
        
        // Debug log
        print("Loading favorites...")
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            // TODO: Get actual user ID from authentication
            let uid = "user123"
            favorites = try await NetworkManager.shared.getFavorites(uid: uid)
            
            // Debug log
            print("Successfully loaded \(favorites.count) favorites")
        } catch {
            self.error = error
            // Debug log
            print("Error loading favorites: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func unfavoriteProperty(_ property: Property) async {
        guard !isFavoriting else { return }
        
        // Debug log
        print("Attempting to unfavorite property: \(property.id)")
        
        isFavoriting = true
        defer { isFavoriting = false }
        
        do {
            // TODO: Get actual user ID from authentication
            let uid = "user123"
            let success = try await NetworkManager.shared.unfavoriteProperty(uid: uid, listingId: property.id)
            
            if success {
                // Remove from local state
                favorites.removeAll { $0.id == property.id }
                // Debug log
                print("Successfully unfavorited property and removed from list")
            }
        } catch {
            // Debug log
            print("Error unfavoriting property: \(error.localizedDescription)")
            // TODO: Show error to user
        }
    }
} 