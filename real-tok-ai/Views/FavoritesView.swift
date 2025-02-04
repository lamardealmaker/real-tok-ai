import SwiftUI

// MARK: - Favorites View
struct FavoritesView: View {
    let model: FavoritesViewModel
    @State private var selectedProperty: Property?
    @State private var showPropertyDetails = false
    
    init() {
        self.model = FavoritesViewModel()
    }
    
    var body: some View {
        NavigationView {
            Group {
                if model.isLoading {
                    ProgressView("Loading favorites...")
                        .scaleEffect(1.5)
                } else if let error = model.error {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.yellow)
                        Text("Error loading favorites")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Button("Try Again") {
                            // Debug log
                            print("Retrying favorites load")
                            Task {
                                await model.loadFavorites()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                } else if model.favorites.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No Favorites Yet")
                            .font(.headline)
                        Text("Properties you favorite will appear here")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(model.favorites) { property in
                                PropertyCard(property: property) {
                                    // Debug log
                                    print("Unfavorite confirmed for property: \(property.id)")
                                    Task {
                                        await model.unfavoriteProperty(property)
                                    }
                                }
                                .onTapGesture {
                                    selectedProperty = property
                                    showPropertyDetails = true
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
        .sheet(isPresented: $showPropertyDetails) {
            if let property = selectedProperty {
                PropertyDetailsOverlay(property: property, isPresented: $showPropertyDetails)
            }
        }
        .onAppear {
            // Debug log
            print("FavoritesView appeared")
            Task {
                await model.loadFavorites()
            }
        }
    }
} 