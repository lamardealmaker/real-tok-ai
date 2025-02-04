import SwiftUI
import UIKit

// MARK: - Share Sheet Helper
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    // Debug log
    init(items: [Any]) {
        print("Initializing ShareSheet with \(items.count) items")
        self.items = items
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        // Debug log
        print("Creating UIActivityViewController")
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Exclude certain activity types that might cause issues
        controller.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .openInIBooks,
            .saveToCameraRoll // Since we're handling images as URLs
        ]
        
        // Handle iPad presentation
        if let popoverController = controller.popoverPresentationController {
            popoverController.permittedArrowDirections = []
            popoverController.sourceView = UIView() // Empty view
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        // Add completion handler for debugging
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if let error = error {
                print("Share error: \(error.localizedDescription)")
                return
            }
            
            if completed {
                print("Share completed via \(activityType?.rawValue ?? "unknown")")
            } else {
                print("Share cancelled")
            }
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
} 