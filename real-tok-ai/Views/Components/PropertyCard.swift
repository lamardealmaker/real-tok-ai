import SwiftUI

// MARK: - Property Card
struct PropertyCard: View {
    let property: Property
    var onUnfavorite: (() -> Void)?
    @State private var showUnfavoriteConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Property Image with Unfavorite Button Overlay
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: property.photos[0])) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipped()
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 160)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray)
                            )
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 160)
                            .overlay(
                                ProgressView()
                                    .scaleEffect(1.5)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                
                if onUnfavorite != nil {
                    Button {
                        // Debug log
                        print("Unfavorite button tapped for property: \(property.id)")
                        showUnfavoriteConfirmation = true
                    } label: {
                        Image(systemName: "heart.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(8)
                }
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(12)
            
            // Property Info
            VStack(alignment: .leading, spacing: 4) {
                Text(property.address.street)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("\(property.bedrooms) bed • \(property.bathrooms) bath")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("$\(Int(property.price))")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .alert("Remove from Favorites?", isPresented: $showUnfavoriteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Remove", role: .destructive) {
                onUnfavorite?()
            }
        } message: {
            Text("This property will be removed from your favorites list.")
        }
    }
} 