
import Foundation
import Combine

enum DashboardMealStatus: String {
    case planned = "Planned"
    case cooked = "Cooked"
    case skipped = "Skipped"
}

struct DashboardMeal: Identifiable {
    let id: UUID
    var name: String
    var mealType: String
    var date: Date
    var status: DashboardMealStatus
    var calories: Int

    init(
        id: UUID = UUID(),
        name: String,
        mealType: String,
        date: Date,
        status: DashboardMealStatus,
        calories: Int
    ) {
        self.id = id
        self.name = name
        self.mealType = mealType
        self.date = date
        self.status = status
        self.calories = calories
    }
}

final class HomeViewModel: ObservableObject {

    @Published var meals: [DashboardMeal] = []

    private let calendar = Calendar.current

    private var currentWeekMeals: [DashboardMeal] {
        guard let interval = calendar.dateInterval(
            of: .weekOfYear,
            for: Date()
        ) else {
            return []
        }

        return meals.filter {
            interval.contains($0.date)
        }
    }

    var totalPlannedMeals: Int {
        currentWeekMeals.count
    }

    var cookedMeals: Int {
        currentWeekMeals.filter {
            $0.status == .cooked
        }.count
    }

    var pendingMeals: Int {
        currentWeekMeals.filter {
            $0.status == .planned
        }.count
    }

    var skippedMeals: Int {
        currentWeekMeals.filter {
            $0.status == .skipped
        }.count
    }

    var progress: Double {
        guard totalPlannedMeals > 0 else {
            return 0
        }

        return Double(cookedMeals) / Double(totalPlannedMeals)
    }

    var nextUpcomingMeal: DashboardMeal? {
        meals
            .filter {
                $0.status == .planned &&
                $0.date >= Date()
            }
            .sorted {
                $0.date < $1.date
            }
            .first
    }

    var weekDescription: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }

    func updateMeals(_ newMeals: [DashboardMeal]) {
        meals = newMeals
    }
}
