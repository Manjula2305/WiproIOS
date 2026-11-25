
import SwiftUI

struct AppCoordinator: View {

    @State private var showSplash = true

    var body: some View {

        Group {
            if showSplash {

                SplashView {
                    withAnimation {
                        showSplash = false
                    }
                }

            } else {

                AuthenticationViews()
            }
        }
    }
}
