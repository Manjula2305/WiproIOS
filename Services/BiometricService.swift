
import Foundation
import LocalAuthentication

final class BiometricService {

    func authenticate(completion: @escaping (Bool, String?) -> Void) {

        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) else {
            DispatchQueue.main.async {
                completion(false, error?.localizedDescription ?? "Face ID is not available.")
            }
            return
        }

        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Login to your MealMate account"
        ) { success, authenticationError in

            DispatchQueue.main.async {
                if success {
                    completion(true, nil)
                } else {
                    completion(false, authenticationError?.localizedDescription ?? "Face ID authentication failed.")
                }
            }
        }
    }
}
