//
//  real_tok_aiApp.swift
//  real-tok-ai
//
//  Created by Learn on 3/02/25.
//

import SwiftUI
import FirebaseCore

@main
struct real_tok_aiApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
