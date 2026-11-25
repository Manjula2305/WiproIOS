import Foundation

final class AuthenticationService {

    private let defaults = UserDefaults.standard
    private let accountsKey = "MealMate_RegisteredAccounts"

    var hasAccount: Bool {
        if defaults.bool(forKey: "hasAccount") {
            return true
        }
        return !allAccounts().isEmpty
    }

    var currentEmail: String {
        defaults.string(forKey: "loggedInEmail") ??
        defaults.string(forKey: "registeredEmail") ?? ""
    }

    var currentName: String {
        defaults.string(forKey: "registeredName") ?? "MealMate User"
    }

    private func allAccounts() -> [String: UserAccount] {
        guard let data = defaults.data(forKey: accountsKey) else {
            // Check legacy account
            if let email = defaults.string(forKey: "registeredEmail"),
               let name = defaults.string(forKey: "registeredName"),
               let pass = defaults.string(forKey: "registeredPassword") {
                return [email.lowercased(): UserAccount(name: name, email: email, password: pass)]
            }
            return [:]
        }
        do {
            return (try JSONDecoder().decode([String: UserAccount].self, from: data))
        } catch {
            return [:]
        }
    }

    private func saveAccounts(_ accounts: [String: UserAccount]) {
        if let data = try? JSONEncoder().encode(accounts) {
            defaults.set(data, forKey: accountsKey)
        }
    }

    func signUp(name: String, email: String, password: String) -> Bool {

        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !cleanName.isEmpty,
              cleanEmail.contains("@"),
              password.count >= 6 else {
            return false
        }

        var accounts = allAccounts()
        let newAccount = UserAccount(name: cleanName, email: cleanEmail, password: password)
        accounts[cleanEmail] = newAccount
        saveAccounts(accounts)

        defaults.set(cleanName, forKey: "registeredName")
        defaults.set(cleanEmail, forKey: "registeredEmail")
        defaults.removeObject(forKey: "loggedInEmail")
        defaults.set(password, forKey: "registeredPassword")
        defaults.set(true, forKey: "hasAccount")

        return true
    }

    func login(email: String, password: String) -> Bool {

        let input = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let accounts = allAccounts()

        // 1. Check in accounts dictionary by email or name
        for (_, account) in accounts {
            if (account.email.lowercased() == input || account.name.lowercased() == input) && account.password == password {
                defaults.set(account.name, forKey: "registeredName")
                defaults.set(account.email, forKey: "registeredEmail")
                defaults.set(account.email, forKey: "loggedInEmail")
                defaults.set(true, forKey: "hasAccount")
                return true
            }
        }

        // 2. Check legacy single account
        let savedEmail = defaults.string(forKey: "registeredEmail")?.lowercased() ?? ""
        let savedName = defaults.string(forKey: "registeredName")?.lowercased() ?? ""
        let savedPassword = defaults.string(forKey: "registeredPassword") ?? ""

        if hasAccount && (input == savedEmail || input == savedName) && password == savedPassword {
            defaults.set(savedEmail, forKey: "loggedInEmail")
            return true
        }

        return false
    }

    func logout() {
        defaults.set(false, forKey: "isLoggedIn")
    }
}
