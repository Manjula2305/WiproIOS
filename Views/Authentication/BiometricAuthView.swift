
import SwiftUI

struct BiometricAuthView: View {

    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: "faceid")
                    .font(.title2)

                Text("Login with Face ID")
                    .font(.headline)
            }
            .foregroundColor(.purple)
            .frame(maxWidth: .infinity)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.purple, lineWidth: 1.5)
            }
        }
    }
}

