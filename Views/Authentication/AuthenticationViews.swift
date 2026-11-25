
import SwiftUI

struct AuthenticationViews: View {

    @AppStorage("hasAccount") private var hasAccount = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    @State private var showSignup = false
    @State private var signupSuccessMessage = ""

    var body: some View {

        Group {
            if isLoggedIn {

                MainTabView()

            } else if showSignup {

                SignupView(
                    onShowLogin: {
                        signupSuccessMessage = ""
                        showSignup = false
                    },
                    onSignupSuccess: {
                        signupSuccessMessage = "Account created successfully! Please login."
                        showSignup = false
                    }
                )

            } else {

                LoginView(
                    successMessage: signupSuccessMessage,
                    onShowSignup: {
                        signupSuccessMessage = ""
                        showSignup = true
                    }
                )
            }
        }
        .onChange(of: isLoggedIn) { _, newValue in
            if newValue {
                signupSuccessMessage = ""
            }
        }
    }
}

