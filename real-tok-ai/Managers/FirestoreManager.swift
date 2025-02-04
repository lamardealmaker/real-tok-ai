import Foundation
import FirebaseFirestore

// MARK: - Firestore Manager
@Observable final class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    // Debug log helper
    private func log(_ message: String) {
        print("[FirestoreManager] \(message)")
    }
    
    func testConnection() async throws -> Bool {
        log("Testing Firestore connection...")
        
        // Try to read a test document
        let testDoc = try await db.collection("test").document("test").getDocument()
        
        // If we get here, the connection is working
        log("✅ Firestore connection successful")
        return true
    }
    
    // MARK: - Listings Management
    
    /// Add a single listing to Firestore
    func addListing(_ property: Property) async throws {
        log("Adding listing: \(property.id)")
        
        try await db.collection("listings")
            .document(property.id)
            .setData(property.asDocument)
        
        log("✅ Successfully added listing: \(property.id)")
    }
    
    /// Get all listings
    func getListings() async throws -> [Property] {
        log("Fetching all listings...")
        
        let snapshot = try await db.collection("listings").getDocuments()
        
        let properties = snapshot.documents.compactMap { document in
            Property(document: document)
        }
        
        log("✅ Successfully fetched \(properties.count) listings")
        return properties
    }
    
    /// Get a single listing by ID
    func getListing(id: String) async throws -> Property? {
        log("Fetching listing: \(id)")
        
        let document = try await db.collection("listings")
            .document(id)
            .getDocument()
        
        guard let property = Property(document: document) else {
            log("❌ Failed to parse listing: \(id)")
            return nil
        }
        
        log("✅ Successfully fetched listing: \(id)")
        return property
    }
} 