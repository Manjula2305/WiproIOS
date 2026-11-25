import SwiftUI

struct ProfileView: View {

    @AppStorage("registeredName")
    private var registeredName = ""

    @AppStorage("registeredEmail")
    private var registeredEmail = ""

    @AppStorage("loggedInEmail")
    private var loggedInEmail = ""

    @AppStorage("isLoggedIn")
    private var isLoggedIn = false

    private let purple = Color(
        red: 0.43,
        green: 0.32,
        blue: 0.60
    )

    private var displayEmail: String {
        if !loggedInEmail.isEmpty {
            return loggedInEmail
        }
        return registeredEmail
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 24) {

                    VStack(spacing: 12) {

                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 85))
                            .foregroundColor(purple)

                        Text(
                            registeredName.isEmpty
                            ? "MealMate User"
                            : registeredName
                        )
                        .font(.title2.bold())

                        Text(displayEmail)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 30)

                    VStack(spacing: 0) {

                        profileRow(
                            icon: "person",
                            title: "Personal Information"
                        )

                        Divider()

                        profileRow(
                            icon: "bell",
                            title: "Notifications"
                        )

                        Divider()

                        profileRow(
                            icon: "lock",
                            title: "Privacy & Security"
                        )

                        Divider()

                        profileRow(
                            icon: "gearshape",
                            title: "Settings"
                        )
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    Button {
                        UserDefaults.standard.removeObject(forKey: "loggedInEmail")
                        isLoggedIn = false
                    } label: {

                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(20)
            }
            .background(
                Color(red: 0.98, green: 0.97, blue: 0.99)
            )
            .navigationTitle("Profile")
        }
    }

    private func profileRow(
        icon: String,
        title: String
    ) -> some View {

        HStack(spacing: 15) {

            Image(systemName: icon)
                .foregroundColor(purple)
                .frame(width: 25)

            Text(title)
                .font(.system(size: 15))

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(17)
    }
}
