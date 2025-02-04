import Foundation
import FirebaseFirestore

public class CSVImporter {
    // Debug log helper
    private static func log(_ message: String) {
        print("[CSVImporter] \(message)")
    }
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    
    // MARK: - CSV Parsing
    public func importListings(from csvString: String) async throws -> [Property] {
        CSVImporter.log("Starting CSV import")
        
        var properties: [Property] = []
        let rows = csvString.components(separatedBy: .newlines)
        
        // Skip header row
        guard rows.count > 1 else {
            let error = NSError(domain: "CSVImporter", code: -1, userInfo: [NSLocalizedDescriptionKey: "CSV file is empty or invalid"])
            CSVImporter.log("Import failed: Empty CSV")
            throw error
        }
        
        let headers = rows[0].components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        for row in rows[1...] {
            guard !row.isEmpty else { continue }
            
            let values = row.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            guard values.count == headers.count else {
                CSVImporter.log("Skipping invalid row: Column count mismatch")
                continue
            }
            
            let data = Dictionary(uniqueKeysWithValues: zip(headers, values))
            if let property = try await createProperty(from: data) {
                properties.append(property)
                CSVImporter.log("Created property: \(property.id)")
            }
        }
        
        CSVImporter.log("Successfully imported \(properties.count) properties")
        return properties
    }
    
    // MARK: - Property Creation
    private func createProperty(from data: [String: String]) async throws -> Property? {
        guard
            let listingId = data["listingId"],
            let street = data["street"],
            let city = data["city"],
            let state = data["state"],
            let zip = data["zip"],
            let priceString = data["price"],
            let price = Double(priceString),
            let propertyType = data["propertyType"],
            let bedroomsString = data["bedrooms"],
            let bedrooms = Int(bedroomsString),
            let bathroomsString = data["bathrooms"],
            let bathrooms = Double(bathroomsString),
            let squareFeetString = data["squareFeet"],
            let squareFeet = Int(squareFeetString),
            let description = data["description"],
            let featuresString = data["features"],
            let photosString = data["photos"],
            let status = data["status"],
            let listingDateString = data["listingDate"],
            let agentName = data["agentName"],
            let agentBrokerage = data["agentBrokerage"]
        else {
            CSVImporter.log("Missing required fields in data")
            return nil
        }
        
        // Parse arrays
        let features = featuresString
            .trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
            .components(separatedBy: ";")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        let photos = photosString
            .trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
            .components(separatedBy: ";")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        // Parse date
        let dateFormatter = ISO8601DateFormatter()
        guard let listingDate = dateFormatter.date(from: listingDateString) else {
            CSVImporter.log("Invalid date format: \(listingDateString)")
            return nil
        }
        
        // Create property
        let property = Property(
            id: listingId,
            address: Address(street: street, city: city, state: state, zip: zip),
            price: price,
            propertyType: propertyType,
            bedrooms: bedrooms,
            bathrooms: bathrooms,
            squareFeet: squareFeet,
            description: description,
            features: features,
            photos: photos,
            status: status,
            listingDate: listingDate,
            agent: Agent(name: agentName, brokerage: agentBrokerage),
            likeCount: 0,
            isFavorited: false
        )
        
        // Save to Firestore
        try await saveToFirestore(property)
        
        return property
    }
    
    // MARK: - Firestore Operations
    private func saveToFirestore(_ property: Property) async throws {
        CSVImporter.log("Saving property to Firestore: \(property.id)")
        
        let propertyRef = db.collection("properties").document(property.id)
        try await propertyRef.setData(property.asDocument)
        
        CSVImporter.log("Successfully saved property to Firestore: \(property.id)")
    }
} 