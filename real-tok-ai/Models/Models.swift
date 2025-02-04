import Foundation
import FirebaseFirestore

// MARK: - Property Model
struct Property: Identifiable, Codable {
    // Debug log helper
    static func log(_ message: String) {
        print("[Property] \(message)")
    }
    
    let id: String // This is the listingId
    let address: Address
    let price: Double
    let propertyType: String
    let bedrooms: Int
    let bathrooms: Double // Using Double to support half baths (e.g., 2.5)
    let squareFeet: Int
    let description: String
    let features: [String]
    let photos: [String]
    let status: String
    let listingDate: Date
    let agent: Agent
    var likeCount: Int
    var isFavorited: Bool // Client-side only
    
    // Firestore document conversion
    var asDocument: [String: Any] {
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
    init?(document: DocumentSnapshot) {
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
}

// MARK: - Address Model
struct Address: Codable {
    let street: String
    let city: String
    let state: String
    let zip: String
}

// MARK: - Agent Model
struct Agent: Codable {
    let name: String
    let brokerage: String
} 