
import Foundation
import Combine

final class AuthViewModel: ObservableObject {

    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""

    private let authService = AuthenticationService()
    private let biometricService = BiometricService()

    func signUp() -> Bool {

        let success = authService.signUp(
            name: name,
            email: email,
            password: password
        )

        if success {
            UserDefaults.standard.set(true, forKey: "biometricEnabled")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            errorMessage = ""
            return true
        }

        errorMessage = "Please enter a valid name, email and password with at least 6 characters."
        return false
    }

    func login() -> Bool {

        if authService.login(email: email, password: password) {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            errorMessage = ""
            return true
        }

        errorMessage = "Incorrect email or password."
        return false
    }

    func loginWithFaceID(completion: @escaping (Bool) -> Void) {

        guard authService.hasAccount else {
            errorMessage = "Please create an account first."
            completion(false)
            return
        }

        guard UserDefaults.standard.bool(forKey: "biometricEnabled") else {
            errorMessage = "Face ID login is not enabled."
            completion(false)
            return
        }

        biometricService.authenticate { [weak self] success, error in

            if success {
                if let registeredEmail = UserDefaults.standard.string(forKey: "registeredEmail") {
                    UserDefaults.standard.set(registeredEmail, forKey: "loggedInEmail")
                }
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self?.errorMessage = ""
                completion(true)
            } else {
                self?.errorMessage = error ?? "Face ID login failed."
                completion(false)
            }
        }
    }
}
