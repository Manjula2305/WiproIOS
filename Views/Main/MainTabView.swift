import SwiftUI

struct MainTabView: View {

    @State private var selectedTab = 0
    @AppStorage("loggedInEmail") private var loggedInEmail = ""

    @StateObject private var mealStore = MealPlannerStore()

    private let purple = Color(
        red: 0.43,
        green: 0.32,
        blue: 0.60
    )

    var body: some View {

        TabView(selection: $selectedTab) {

            HomeView(
                onOpenMeals: {
                    selectedTab = 1
                },
                onAddMeal: {
                    selectedTab = 2
                }
            )
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)

            MealsView()
                .tabItem {
                    Label("Meals", systemImage: "calendar")
                }
                .tag(1)

            AddMealView(
                onMealSaved: {
                    selectedTab = 1
                }
            )
            .tabItem {
                Label("Add", systemImage: "plus.circle")
            }
            .tag(2)

            MealListView()
                .tabItem {
                    Label("List", systemImage: "list.bullet.rectangle")
                }
                .tag(3)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(4)
        }
        .tint(purple)
        .environmentObject(mealStore)
        .onAppear {
            mealStore.reloadForCurrentUser()
        }
        .onChange(of: loggedInEmail) { _, _ in
            mealStore.reloadForCurrentUser()
        }
    }
}
