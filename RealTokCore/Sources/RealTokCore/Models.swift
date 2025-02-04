import Foundation
import FirebaseFirestore

// MARK: - Property Model
public struct Property: Identifiable, Codable {
    // Debug log helper
    public static func log(_ message: String) {
        print("[Property] \(message)")
    }
    
    public let id: String // This is the listingId
    public let address: Address
    public let price: Double
    public let propertyType: String
    public let bedrooms: Int
    public let bathrooms: Double // Using Double to support half baths (e.g., 2.5)
    public let squareFeet: Int
    public let description: String
    public let features: [String]
    public let photos: [String]
    public let status: String
    public let listingDate: Date
    public let agent: Agent
    public var likeCount: Int
    public var isFavorited: Bool // Client-side only
    
    // Firestore document conversion
    public var asDocument: [String: Any] {
        return [
            "listingId": id,
            "address": [
                "street": address.street,
                "city": address.city,
                "state": address.state,
                "zip": address.zip
            ],
            "price": price,
            "propertyType": propertyType,
            "bedrooms": bedrooms,
            "bathrooms": bathrooms,
            "squareFeet": squareFeet,
            "description": description,
            "features": features,
            "photos": photos,
            "status": status,
            "listingDate": Timestamp(date: listingDate),
            "agent": [
                "name": agent.name,
                "brokerage": agent.brokerage
            ],
            "likeCount": likeCount
        ]
    }
    
    // Initialize from Firestore document
    public init?(document: DocumentSnapshot) {
        guard 
            let data = document.data(),
            let id = data["listingId"] as? String,
            let addressData = data["address"] as? [String: Any],
            let street = addressData["street"] as? String,
            let city = addressData["city"] as? String,
            let state = addressData["state"] as? String,
            let zip = addressData["zip"] as? String,
            let price = data["price"] as? Double,
            let propertyType = data["propertyType"] as? String,
            let bedrooms = data["bedrooms"] as? Int,
            let bathrooms = data["bathrooms"] as? Double,
            let squareFeet = data["squareFeet"] as? Int,
            let description = data["description"] as? String,
            let features = data["features"] as? [String],
            let photos = data["photos"] as? [String],
            let status = data["status"] as? String,
            let listingDate = (data["listingDate"] as? Timestamp)?.dateValue(),
            let agentData = data["agent"] as? [String: Any],
            let agentName = agentData["name"] as? String,
            let agentBrokerage = agentData["brokerage"] as? String,
            let likeCount = data["likeCount"] as? Int
        else {
            Property.log("Failed to initialize Property from document: \(document.documentID)")
            return nil
        }
        
        self.id = id
        self.address = Address(street: street, city: city, state: state, zip: zip)
        self.price = price
        self.propertyType = propertyType
        self.bedrooms = bedrooms
        self.bathrooms = bathrooms
        self.squareFeet = squareFeet
        self.description = description
        self.features = features
        self.photos = photos
        self.status = status
        self.listingDate = listingDate
        self.agent = Agent(name: agentName, brokerage: agentBrokerage)
        self.likeCount = likeCount
        self.isFavorited = false // Will be set by the client based on user's favorites
        
        Property.log("Successfully initialized Property: \(id)")
    }
    
    // Public initializer for creating properties
    public init(id: String, address: Address, price: Double, propertyType: String, bedrooms: Int, bathrooms: Double, squareFeet: Int, description: String, features: [String], photos: [String], status: String, listingDate: Date, agent: Agent, likeCount: Int, isFavorited: Bool) {
        self.id = id
        self.address = address
        self.price = price
        self.propertyType = propertyType
        self.bedrooms = bedrooms
        self.bathrooms = bathrooms
        self.squareFeet = squareFeet
        self.description = description
        self.features = features
        self.photos = photos
        self.status = status
        self.listingDate = listingDate
        self.agent = agent
        self.likeCount = likeCount
        self.isFavorited = isFavorited
    }
}

// MARK: - Address Model
public struct Address: Codable {
    public let street: String
    public let city: String
    public let state: String
    public let zip: String
    
    public init(street: String, city: String, state: String, zip: String) {
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
    }
}

// MARK: - Agent Model
public struct Agent: Codable {
    public let name: String
    public let brokerage: String
    
    public init(name: String, brokerage: String) {
        self.name = name
        self.brokerage = brokerage
    }
} 