import Foundation
import SwiftUI

// Import our models
@_exported import struct Models.Property
@_exported import struct Models.Address
@_exported import struct Models.Agent

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
                status: "Active",
                listingDate: Date(),
                agent: Agent(name: "Jane Smith", brokerage: "ABC Realty"),
                likeCount: 0,
                isFavorited: true
            )
        ]
    }
} 