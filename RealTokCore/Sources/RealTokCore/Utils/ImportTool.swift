import Foundation
import FirebaseCore
import FirebaseFirestore

@main
struct ImportTool {
    // Debug log helper
    private static func log(_ message: String) {
        print("[ImportTool] \(message)")
    }
    
    static func main() async throws {
        // Initialize Firebase
        FirebaseApp.configure()
        ImportTool.log("Firebase configured")
        
        // Get CSV file path from command line arguments
        guard CommandLine.arguments.count > 1 else {
            ImportTool.log("Error: Please provide the CSV file path as an argument")
            return
        }
        
        let filePath = CommandLine.arguments[1]
        ImportTool.log("Reading CSV file: \(filePath)")
        
        // Read CSV file
        guard let csvString = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            ImportTool.log("Error: Could not read CSV file")
            return
        }
        
        // Import listings
        let importer = CSVImporter()
        do {
            let properties = try await importer.importListings(from: csvString)
            ImportTool.log("Successfully imported \(properties.count) properties")
        } catch {
            ImportTool.log("Import failed: \(error.localizedDescription)")
        }
    }
} 