import Foundation
import FirebaseFirestore

// MARK: - NetworkManager
public class NetworkManager {
    // Debug log helper
    private static func log(_ message: String) {
        print("[NetworkManager] \(message)")
    }
    
    private let db = Firestore.firestore()
    
    public init() {
        NetworkManager.log("Initialized NetworkManager")
    }
    
    // MARK: - Properties
    
    public func fetchProperties() async throws -> [Property] {
        NetworkManager.log("Fetching properties...")
        
        let snapshot = try await db.collection("properties").getDocuments()
        let properties = snapshot.documents.compactMap { Property(document: $0) }
        
        NetworkManager.log("Fetched \(properties.count) properties")
        return properties
    }
    
    public func likeProperty(_ property: Property) async throws {
        NetworkManager.log("Liking property: \(property.id)")
        
        let propertyRef = db.collection("properties").document(property.id)
        try await propertyRef.updateData([
            "likeCount": FieldValue.increment(Int64(1))
        ])
        
        NetworkManager.log("Successfully liked property: \(property.id)")
    }
    
    public func favoriteProperty(_ property: Property, userId: String) async throws {
        NetworkManager.log("Favoriting property: \(property.id) for user: \(userId)")
        
        let favoriteRef = db.collection("favorites").document("\(userId)_\(property.id)")
        try await favoriteRef.setData([
            "userId": userId,
            "propertyId": property.id,
            "timestamp": FieldValue.serverTimestamp()
        ])
        
        NetworkManager.log("Successfully favorited property: \(property.id)")
    }
    
    public func unfavoriteProperty(_ property: Property, userId: String) async throws {
        NetworkManager.log("Unfavoriting property: \(property.id) for user: \(userId)")
        
        let favoriteRef = db.collection("favorites").document("\(userId)_\(property.id)")
        try await favoriteRef.delete()
        
        NetworkManager.log("Successfully unfavorited property: \(property.id)")
    }
    
    public func getFavorites(userId: String) async throws -> [Property] {
        NetworkManager.log("Fetching favorites for user: \(userId)")
        
        let snapshot = try await db.collection("favorites")
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        let propertyIds = snapshot.documents.compactMap { $0.get("propertyId") as? String }
        var properties: [Property] = []
        
        for id in propertyIds {
            if let propertyDoc = try await db.collection("properties").document(id).getDocument(),
               let property = Property(document: propertyDoc) {
                properties.append(property)
            }
        }
        
        NetworkManager.log("Fetched \(properties.count) favorites")
        return properties
    }
} 