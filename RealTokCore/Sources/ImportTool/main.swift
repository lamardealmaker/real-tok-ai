import Foundation
import FirebaseCore
import FirebaseFirestore
import RealTokCore

// Debug log helper
private func log(_ message: String) {
    print("[ImportTool] \(message)")
}

// Main execution
do {
    // Initialize Firebase
    FirebaseApp.configure()
    log("Firebase configured")
    
    // Get CSV file path from command line arguments
    guard CommandLine.arguments.count > 1 else {
        log("Error: Please provide the CSV file path as an argument")
        exit(1)
    }
    
    let filePath = CommandLine.arguments[1]
    log("Reading CSV file: \(filePath)")
    
    // Read CSV file
    guard let csvString = try? String(contentsOfFile: filePath, encoding: .utf8) else {
        log("Error: Could not read CSV file")
        exit(1)
    }
    
    // Import listings
    let importer = CSVImporter()
    do {
        let properties = try await importer.importListings(from: csvString)
        log("Successfully imported \(properties.count) properties")
        exit(0)
    } catch {
        log("Import failed: \(error.localizedDescription)")
        exit(1)
    }
} catch {
    log("Unexpected error: \(error.localizedDescription)")
    exit(1)
} 