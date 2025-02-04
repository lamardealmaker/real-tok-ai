import Foundation
import SwiftUI
import FirebaseAuth

@Observable
public class AppViewModel {
    // Debug log helper
    private static func log(_ message: String) {
        print("[AppViewModel] \(message)")
    }
    
    // MARK: - Properties
    public let authManager: AuthManager
    public let propertyViewModel: PropertyViewModel
    public let storageManager: StorageManager
    
    public var isAuthenticated: Bool { authManager.isAuthenticated }
    public var currentUser: User? { authManager.currentUser }
    public var error: Error?
    
    // MARK: - Initialization
    public init() {
        self.authManager = AuthManager()
        self.storageManager = StorageManager()
        self.propertyViewModel = PropertyViewModel()
        AppViewModel.log("Initialized AppViewModel")
    }
    
    // MARK: - App State Methods
    public func handleDeepLink(_ url: URL) {
        AppViewModel.log("Handling deep link: \(url)")
        // TODO: Implement deep link handling
    }
    
    public func handlePushNotification(_ userInfo: [AnyHashable: Any]) {
        AppViewModel.log("Handling push notification: \(userInfo)")
        // TODO: Implement push notification handling
    }
    
    public func handleError(_ error: Error) {
        self.error = error
        AppViewModel.log("Handling error: \(error.localizedDescription)")
        // TODO: Implement error handling (e.g., show alert, log to analytics)
    }
    
    // MARK: - App Lifecycle Methods
    public func appDidBecomeActive() {
        AppViewModel.log("App did become active")
        // TODO: Implement app activation handling
    }
    
    public func appWillResignActive() {
        AppViewModel.log("App will resign active")
        // TODO: Implement app deactivation handling
    }
    
    public func appDidEnterBackground() {
        AppViewModel.log("App did enter background")
        // TODO: Implement background state handling
    }
    
    public func appWillEnterForeground() {
        AppViewModel.log("App will enter foreground")
        // TODO: Implement foreground state handling
    }
    
    // MARK: - User Session Methods
    public func refreshUserSession() async {
        AppViewModel.log("Refreshing user session")
        // TODO: Implement session refresh logic
    }
    
    public func clearUserData() {
        AppViewModel.log("Clearing user data")
        // Clear all local data
        propertyViewModel.properties = []
        propertyViewModel.currentIndex = 0
        error = nil
    }
    
    public func handleSignOut() {
        AppViewModel.log("Handling sign out")
        
        do {
            try authManager.signOut()
            clearUserData()
            AppViewModel.log("Successfully signed out and cleared data")
        } catch {
            self.error = error
            AppViewModel.log("Sign out failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Settings Methods
    public func updateAppSettings(_ settings: [String: Any]) {
        AppViewModel.log("Updating app settings: \(settings)")
        // TODO: Implement settings update logic
    }
    
    public func syncAppSettings() async {
        AppViewModel.log("Syncing app settings")
        // TODO: Implement settings sync logic
    }
} 