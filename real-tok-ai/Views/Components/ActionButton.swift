import SwiftUI

// MARK: - Action Button Component
struct ActionButton: View {
    let icon: String
    let count: String
    var isActive: Bool = false
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { action?() }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 35, weight: .semibold))
                    .foregroundColor(isActive ? .red : .white)
                    .shadow(radius: 5)
                Text(count)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
} 