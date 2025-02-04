//
//  real_tok_aiApp.swift
//  real-tok-ai
//
//  Created by Learn on 3/02/25.
//

import SwiftUI
import FirebaseCore
import RealTokCore

@main
struct RealTokAIApp: App {
    // Debug log helper
    private static func log(_ message: String) {
        print("[RealTokAIApp] \(message)")
    }
    
    // MARK: - Properties
    @State private var model = AppViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @State private var showError = false
    
    // MARK: - Initialization
    init() {
        FirebaseApp.configure()
        RealTokAIApp.log("Firebase configured")
    }
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            if model.isAuthenticated {
                TabView {
                    // Video Feed
                    VideoFeedView(model: model.propertyViewModel, userId: model.currentUser?.uid ?? "")
                        .tabItem {
                            Label("Feed", systemImage: "play.rectangle")
                        }
                    
                    // Favorites
                    FavoritesView(model: model.propertyViewModel, userId: model.currentUser?.uid ?? "")
                        .tabItem {
                            Label("Favorites", systemImage: "bookmark")
                        }
                    
                    // Profile
                    ProfileView(userId: model.currentUser?.uid ?? "", model: model)
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                }
                .onAppear {
                    RealTokAIApp.log("Main view appeared")
                }
            } else {
                AuthView(authManager: model.authManager)
                    .onAppear {
                        RealTokAIApp.log("Auth view appeared")
                    }
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                model.appDidBecomeActive()
            case .inactive:
                model.appWillResignActive()
            case .background:
                model.appDidEnterBackground()
            @unknown default:
                break
            }
        }
        .onChange(of: model.error) { _, error in
            if error != nil {
                showError = true
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {
                model.error = nil
            }
        } message: {
            if let error = model.error {
                Text(error.localizedDescription)
            }
        }
    }
}

// MARK: - FavoritesView
struct FavoritesView: View {
    // Debug log helper
    private static func log(_ message: String) {
        print("[FavoritesView] \(message)")
    }
    
    // MARK: - Properties
    private let model: PropertyViewModel
    private let userId: String
    
    // MARK: - Initialization
    init(model: PropertyViewModel, userId: String) {
        self.model = model
        self.userId = userId
        FavoritesView.log("Initialized FavoritesView")
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Group {
                if model.isLoading {
                    ProgressView()
                } else if model.properties.isEmpty {
                    ContentUnavailableView(
                        "No Favorites",
                        systemImage: "bookmark",
                        description: Text("Properties you favorite will appear here")
                    )
                } else {
                    List(model.properties) { property in
                        PropertyRow(property: property)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
        .task {
            await model.loadFavorites(userId: userId)
            FavoritesView.log("Started loading favorites")
        }
    }
}

// MARK: - PropertyRow
struct PropertyRow: View {
    let property: Property
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Main Info
            HStack {
                Text(String(format: "$%.0f", property.price))
                    .font(.headline)
                Spacer()
                Text(property.propertyType)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Address
            Text("\(property.address.street)")
                .font(.subheadline)
            Text("\(property.address.city), \(property.address.state) \(property.address.zip)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Stats
            HStack(spacing: 16) {
                Label("\(property.bedrooms)", systemImage: "bed.double")
                Label(String(format: "%.1f", property.bathrooms), systemImage: "shower")
                Label("\(property.squareFeet) sqft", systemImage: "ruler")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - ProfileView
struct ProfileView: View {
    // Debug log helper
    private static func log(_ message: String) {
        print("[ProfileView] \(message)")
    }
    
    // MARK: - Properties
    let userId: String
    let model: AppViewModel
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // MARK: - Initialization
    init(userId: String, model: AppViewModel) {
        self.userId = userId
        self.model = model
        ProfileView.log("Initialized ProfileView")
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                Section {
                    // User Info
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                        VStack(alignment: .leading) {
                            Text(model.currentUser?.displayName ?? "Test User")
                                .font(.headline)
                            Text(userId)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Preferences") {
                    NavigationLink {
                        Text("Search Filters")
                    } label: {
                        Label("Search Filters", systemImage: "slider.horizontal.3")
                    }
                    
                    NavigationLink {
                        Text("Notifications")
                    } label: {
                        Label("Notifications", systemImage: "bell")
                    }
                }
                
                Section("Account") {
                    NavigationLink {
                        Text("Settings")
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                    
                    Button(role: .destructive) {
                        handleSignOut()
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profile")
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Sign Out Method
    private func handleSignOut() {
        ProfileView.log("Handling sign out")
        model.handleSignOut()
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
        ProfileView.log("Showing alert: \(title) - \(message)")
    }
}
