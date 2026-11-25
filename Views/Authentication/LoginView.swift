import SwiftUI

struct LoginView: View {

    @StateObject private var viewModel = AuthViewModel()

    var successMessage: String = ""
    var onShowSignup: () -> Void

    var body: some View {

        VStack(spacing: 22) {

            Spacer()

            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)

            if !successMessage.isEmpty && viewModel.errorMessage.isEmpty {
                Text(successMessage)
                    .foregroundColor(.green)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }

            TextField("Email or Username", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .background(Color.gray.opacity(0.12))
                .cornerRadius(12)

            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.12))
                .cornerRadius(12)

            Button {
                _ = viewModel.login()
            } label: {
                Text("Login")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(12)
            }

            // Face ID button directly below Login.
            BiometricAuthView {
                viewModel.loginWithFaceID { _ in }
            }

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.secondary)

                Button("Sign Up") {
                    onShowSignup()
                }
                .fontWeight(.bold)
                .foregroundColor(.purple)
            }
        }
        .padding(25)
    }
}
