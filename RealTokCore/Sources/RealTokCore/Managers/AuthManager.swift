import Foundation
import FirebaseAuth

@Observable
public class AuthManager {
    // Debug log helper
    private static func log(_ message: String) {
        print("[AuthManager] \(message)")
    }
    
    // MARK: - Properties
    public var currentUser: User?
    public var isAuthenticated: Bool { currentUser != nil }
    public var error: Error?
    
    // MARK: - Initialization
    public init() {
        setupAuthStateListener()
        AuthManager.log("Initialized AuthManager")
    }
    
    // MARK: - Auth State
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
            AuthManager.log(user != nil ? "User signed in: \(user!.uid)" : "User signed out")
        }
    }
    
    // MARK: - Sign In
    public func signIn(email: String, password: String) async throws {
        AuthManager.log("Attempting to sign in with email: \(email)")
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.currentUser = result.user
            AuthManager.log("Successfully signed in user: \(result.user.uid)")
        } catch {
            self.error = error
            AuthManager.log("Sign in failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Sign Up
    public func signUp(email: String, password: String) async throws {
        AuthManager.log("Attempting to create account with email: \(email)")
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.currentUser = result.user
            AuthManager.log("Successfully created account for user: \(result.user.uid)")
        } catch {
            self.error = error
            AuthManager.log("Account creation failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Sign Out
    public func signOut() throws {
        AuthManager.log("Attempting to sign out")
        
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            AuthManager.log("Successfully signed out")
        } catch {
            self.error = error
            AuthManager.log("Sign out failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Password Reset
    public func resetPassword(email: String) async throws {
        AuthManager.log("Attempting to send password reset email to: \(email)")
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            AuthManager.log("Successfully sent password reset email")
        } catch {
            self.error = error
            AuthManager.log("Password reset failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Update Profile
    public func updateProfile(displayName: String?, photoURL: URL?) async throws {
        guard let user = currentUser else {
            let error = NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            AuthManager.log("Update profile failed: No user logged in")
            throw error
        }
        
        AuthManager.log("Attempting to update profile for user: \(user.uid)")
        
        let changeRequest = user.createProfileChangeRequest()
        if let displayName = displayName {
            changeRequest.displayName = displayName
        }
        if let photoURL = photoURL {
            changeRequest.photoURL = photoURL
        }
        
        do {
            try await changeRequest.commitChanges()
            AuthManager.log("Successfully updated profile")
        } catch {
            self.error = error
            AuthManager.log("Profile update failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Delete Account
    public func deleteAccount() async throws {
        guard let user = currentUser else {
            let error = NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
            AuthManager.log("Delete account failed: No user logged in")
            throw error
        }
        
        AuthManager.log("Attempting to delete account for user: \(user.uid)")
        
        do {
            try await user.delete()
            self.currentUser = nil
            AuthManager.log("Successfully deleted account")
        } catch {
            self.error = error
            AuthManager.log("Account deletion failed: \(error.localizedDescription)")
            throw error
        }
    }
} 