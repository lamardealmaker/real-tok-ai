import SwiftUI
import FirebaseAuth

public struct AuthView: View {
    // Debug log helper
    private static func log(_ message: String) {
        print("[AuthView] \(message)")
    }
    
    // MARK: - Properties
    private let authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var showForgotPassword = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // MARK: - Initialization
    public init(authManager: AuthManager) {
        self.authManager = authManager
        AuthView.log("Initialized AuthView")
    }
    
    // MARK: - Body
    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo or App Name
                Text("RealTok")
                    .font(.largeTitle)
                    .bold()
                
                // Email Field
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                // Password Field
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(isSignUp ? .newPassword : .password)
                
                // Sign In/Up Button
                Button(action: {
                    Task {
                        await handleAuth()
                    }
                }) {
                    Text(isSignUp ? "Sign Up" : "Sign In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                // Toggle Sign In/Up
                Button(action: {
                    isSignUp.toggle()
                    AuthView.log("Toggled to \(isSignUp ? "Sign Up" : "Sign In") mode")
                }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }
                
                // Forgot Password
                if !isSignUp {
                    Button("Forgot Password?") {
                        showForgotPassword = true
                        AuthView.log("Showing forgot password sheet")
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView(authManager: authManager)
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Auth Methods
    private func handleAuth() async {
        AuthView.log("Handling \(isSignUp ? "sign up" : "sign in")")
        
        guard !email.isEmpty && !password.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        do {
            if isSignUp {
                try await authManager.signUp(email: email, password: password)
                AuthView.log("Successfully signed up")
            } else {
                try await authManager.signIn(email: email, password: password)
                AuthView.log("Successfully signed in")
            }
        } catch {
            showAlert(title: "Error", message: error.localizedDescription)
            AuthView.log("Auth failed: \(error.localizedDescription)")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
        AuthView.log("Showing alert: \(title) - \(message)")
    }
}

// MARK: - Forgot Password View
struct ForgotPasswordView: View {
    // Debug log helper
    private static func log(_ message: String) {
        print("[ForgotPasswordView] \(message)")
    }
    
    // MARK: - Properties
    private let authManager: AuthManager
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // MARK: - Initialization
    init(authManager: AuthManager) {
        self.authManager = authManager
        ForgotPasswordView.log("Initialized ForgotPasswordView")
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.title)
                    .padding(.top)
                
                Text("Enter your email address and we'll send you a link to reset your password.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                Button(action: {
                    Task {
                        await handlePasswordReset()
                    }
                }) {
                    Text("Send Reset Link")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding()
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
                ForgotPasswordView.log("Dismissed view")
            })
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                if alertTitle == "Success" {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Password Reset Method
    private func handlePasswordReset() async {
        ForgotPasswordView.log("Handling password reset for email: \(email)")
        
        guard !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email address")
            return
        }
        
        do {
            try await authManager.resetPassword(email: email)
            showAlert(title: "Success", message: "Password reset email sent. Please check your inbox.")
            ForgotPasswordView.log("Successfully sent password reset email")
        } catch {
            showAlert(title: "Error", message: error.localizedDescription)
            ForgotPasswordView.log("Password reset failed: \(error.localizedDescription)")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
        ForgotPasswordView.log("Showing alert: \(title) - \(message)")
    }
} 