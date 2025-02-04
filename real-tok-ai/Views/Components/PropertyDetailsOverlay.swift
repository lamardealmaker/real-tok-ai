import SwiftUI

// MARK: - Property Details Overlay
struct PropertyDetailsOverlay: View {
    let property: Property
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.85)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            // Property Details Card
            VStack(alignment: .leading, spacing: 20) {
                // Header with close button
                HStack {
                    Text("Property Details")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Main Details
                        Group {
                            Text("\(property.address.street)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("\(property.address.city), \(property.address.state) \(property.address.zip)")
                                .foregroundColor(.gray)
                            
                            Text("$\(Int(property.price))")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        // Property Specs
                        HStack(spacing: 20) {
                            PropertySpec(icon: "bed.double.fill", value: "\(property.bedrooms)", label: "Beds")
                            PropertySpec(icon: "shower.fill", value: "\(property.bathrooms)", label: "Baths")
                            PropertySpec(icon: "square.fill", value: "\(property.squareFeet)", label: "Sq Ft")
                        }
                        
                        // Description
                        Text("Description")
                            .font(.headline)
                        Text(property.description)
                            .foregroundColor(.gray)
                        
                        // Features
                        Text("Features")
                            .font(.headline)
                        ForEach(property.features, id: \.self) { feature in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(feature)
                            }
                        }
                        
                        // Agent Info
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Listed By")
                                .font(.headline)
                            Text("\(property.agent.name)")
                                .fontWeight(.semibold)
                            Text("\(property.agent.brokerage)")
                                .foregroundColor(.gray)
                        }
                        .padding(.top)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
        }
    }
}

// MARK: - Property Spec Component
struct PropertySpec: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
} 