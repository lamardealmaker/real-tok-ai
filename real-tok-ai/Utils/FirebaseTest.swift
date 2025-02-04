import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseFunctions

// This is just a test file to verify Firebase dependencies
// We can delete it after confirmation
struct FirebaseTest {
    static func testFirebaseSetup() {
        // Debug log
        print("Testing Firebase setup...")
        
        // Test Firestore
        let db = Firestore.firestore()
        print("✅ Firestore initialized")
        
        // Test Storage
        let storage = Storage.storage()
        print("✅ Storage initialized")
        
        // Test Functions
        let functions = Functions.functions()
        print("✅ Functions initialized")
    }
} 