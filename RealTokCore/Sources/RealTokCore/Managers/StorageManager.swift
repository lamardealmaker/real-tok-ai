import Foundation
import FirebaseStorage

@Observable
public class StorageManager {
    // Debug log helper
    private static func log(_ message: String) {
        print("[StorageManager] \(message)")
    }
    
    // MARK: - Properties
    private let storage = Storage.storage()
    public var error: Error?
    
    // MARK: - Initialization
    public init() {
        StorageManager.log("Initialized StorageManager")
    }
    
    // MARK: - Upload Methods
    public func uploadPropertyVideo(propertyId: String, videoData: Data) async throws -> URL {
        StorageManager.log("Uploading video for property: \(propertyId)")
        
        let videoRef = storage.reference().child("properties/\(propertyId)/video.mp4")
        let metadata = StorageMetadata()
        metadata.contentType = "video/mp4"
        
        do {
            _ = try await videoRef.putDataAsync(videoData, metadata: metadata)
            let downloadURL = try await videoRef.downloadURL()
            StorageManager.log("Successfully uploaded video: \(downloadURL.absoluteString)")
            return downloadURL
        } catch {
            self.error = error
            StorageManager.log("Video upload failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    public func uploadPropertyImage(propertyId: String, imageData: Data, index: Int) async throws -> URL {
        StorageManager.log("Uploading image \(index) for property: \(propertyId)")
        
        let imageRef = storage.reference().child("properties/\(propertyId)/image\(index).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        do {
            _ = try await imageRef.putDataAsync(imageData, metadata: metadata)
            let downloadURL = try await imageRef.downloadURL()
            StorageManager.log("Successfully uploaded image: \(downloadURL.absoluteString)")
            return downloadURL
        } catch {
            self.error = error
            StorageManager.log("Image upload failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    public func uploadProfileImage(userId: String, imageData: Data) async throws -> URL {
        StorageManager.log("Uploading profile image for user: \(userId)")
        
        let imageRef = storage.reference().child("users/\(userId)/profile.jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        do {
            _ = try await imageRef.putDataAsync(imageData, metadata: metadata)
            let downloadURL = try await imageRef.downloadURL()
            StorageManager.log("Successfully uploaded profile image: \(downloadURL.absoluteString)")
            return downloadURL
        } catch {
            self.error = error
            StorageManager.log("Profile image upload failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Delete Methods
    public func deletePropertyMedia(propertyId: String) async throws {
        StorageManager.log("Deleting media for property: \(propertyId)")
        
        let propertyRef = storage.reference().child("properties/\(propertyId)")
        
        do {
            try await propertyRef.delete()
            StorageManager.log("Successfully deleted property media")
        } catch {
            self.error = error
            StorageManager.log("Media deletion failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    public func deleteUserMedia(userId: String) async throws {
        StorageManager.log("Deleting media for user: \(userId)")
        
        let userRef = storage.reference().child("users/\(userId)")
        
        do {
            try await userRef.delete()
            StorageManager.log("Successfully deleted user media")
        } catch {
            self.error = error
            StorageManager.log("User media deletion failed: \(error.localizedDescription)")
            throw error
        }
    }
} 