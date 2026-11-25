
import SwiftUI

struct SignupView: View {

    @StateObject private var viewModel = AuthViewModel()

    var onShowLogin: () -> Void
    var onSignupSuccess: (() -> Void)? = nil

    var body: some View {

        ScrollView {
            VStack(spacing: 22) {

                Spacer(minLength: 35)

                // App Logo
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)

                // Heading
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("Join MealMate and plan your meals easily.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                // Name Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Name")
                        .font(.headline)

                    TextField("Enter your full name", text: $viewModel.name)
                        .textContentType(.name)
                        .textInputAutocapitalization(.words)
                        .padding()
                        .background(Color.gray.opacity(0.12))
                        .cornerRadius(12)
                }

                // Email Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email Address")
                        .font(.headline)

                    TextField("Enter your email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(Color.gray.opacity(0.12))
                        .cornerRadius(12)
                }

                // Password Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.headline)

                    SecureField("Create password (minimum 6 characters)", text: $viewModel.password)
                        .textContentType(.newPassword)
                        .padding()
                        .background(Color.gray.opacity(0.12))
                        .cornerRadius(12)
                }

                // Error Message
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                // Create Account Button
                Button {
                    if viewModel.signUp() {
                        if let onSignupSuccess {
                            onSignupSuccess()
                        } else {
                            onShowLogin()
                        }
                    }
                } label: {
                    Text("Create Account")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(12)
                }

                // Login Navigation
                HStack(spacing: 5) {
                    Text("Already have an account?")
                        .foregroundColor(.secondary)

                    Button("Login") {
                        onShowLogin()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                }

                Spacer(minLength: 25)
            }
            .padding(25)
        }
    }
}

