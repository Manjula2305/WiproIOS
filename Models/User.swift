import Foundation

struct UserAccount: Codable, Identifiable {
    var id: String { email.lowercased() }
    let name: String
    let email: String
    let password: String
}
