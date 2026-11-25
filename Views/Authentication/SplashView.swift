import SwiftUI

struct SplashView: View {

    var onFinish: () -> Void

    var body: some View {
        ZStack {
            // Soft lavender background matching the screenshot
            Color(red: 0.94, green: 0.91, blue: 1.0)
                .ignoresSafeArea()

            VStack(spacing: 22) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 155, height: 155)

                Text("Eat Food • Feel Good")
                    .font(.system(size: 19, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.45, green: 0.38, blue: 0.60))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onFinish()
            }
        }
    }
}
