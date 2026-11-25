
import Foundation
import Combine

final class MealPlannerViewModel: ObservableObject {

    // MARK: - Shared Data

    @Published private(set) var meals: [MealPlanItem] = []

    private let storageKey: String

    // MARK: - Initialization

    init(userID: String? = nil) {

        let savedUserID = userID ??
            UserDefaults.standard.string(
                forKey: "loggedInEmail"
            ) ?? "guest"

        let normalizedID = savedUserID
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        storageKey = "MealMate.Meals.\(normalizedID)"

        loadMeals()
    }

    // MARK: - Add Meal

    @discardableResult
    func addMeal(_ meal: MealPlanItem) -> Bool {

        let selectedDate = Calendar.current.startOfDay(
            for: meal.date
        )

        let today = Calendar.current.startOfDay(
            for: Date()
        )

        guard selectedDate >= today else {
            return false
        }

        guard !meal.dishName.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {
            return false
        }

        guard meal.servings > 0 else {
            return false
        }

        meals.append(meal)

        saveMeals()

        return true
    }

    // MARK: - Edit Meal

    @discardableResult
    func updateMeal(_ updatedMeal: MealPlanItem) -> Bool {

        guard let index = meals.firstIndex(
            where: { $0.id == updatedMeal.id }
        ) else {
            return false
        }

        let newName = updatedMeal.dishName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !newName.isEmpty,
              updatedMeal.servings > 0 else {
            return false
        }

        let today = Calendar.current.startOfDay(
            for: Date()
        )

        let newDate = Calendar.current.startOfDay(
            for: updatedMeal.date
        )

        guard newDate >= today else {
            return false
        }

        var meal = updatedMeal
        meal.dishName = newName
        meal.date = newDate

        meals[index] = meal

        saveMeals()

        return true
    }

    // MARK: - Update Status

    func updateStatus(
        for mealID: UUID,
        status: MealPlanStatus
    ) {

        guard let index = meals.firstIndex(
            where: { $0.id == mealID }
        ) else {
            return
        }

        meals[index].status = status

        saveMeals()
    }

    // MARK: - Delete Meal

    func deleteMeal(_ meal: MealPlanItem) {

        meals.removeAll {
            $0.id == meal.id
        }

        saveMeals()
    }

    // MARK: - Today's Meals

    func meals(for date: Date) -> [MealPlanItem] {

        meals
            .filter {
                Calendar.current.isDate(
                    $0.date,
                    inSameDayAs: date
                )
            }
            .sorted {
                $0.mealType < $1.mealType
            }
    }

    // MARK: - Weekly Meals

    func meals(forWeekContaining date: Date) -> [MealPlanItem] {

        var calendar = Calendar.current
        calendar.firstWeekday = 2

        guard let weekInterval = calendar.dateInterval(
            of: .weekOfYear,
            for: date
        ) else {
            return []
        }

        return meals
            .filter {
                $0.date >= weekInterval.start &&
                $0.date < weekInterval.end
            }
            .sorted {
                if $0.date == $1.date {
                    return $0.mealType < $1.mealType
                }

                return $0.date < $1.date
            }
    }

    // MARK: - Search

    func searchMeals(_ query: String) -> [MealPlanItem] {

        let searchText = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !searchText.isEmpty else {
            return meals
        }

        return meals.filter {
            $0.dishName.localizedCaseInsensitiveContains(
                searchText
            ) ||
            $0.mealType.localizedCaseInsensitiveContains(
                searchText
            )
        }
    }

    // MARK: - Dashboard Counts

    var plannedCount: Int {
        meals.filter { $0.status == .planned }.count
    }

    var cookedCount: Int {
        meals.filter { $0.status == .cooked }.count
    }

    var skippedCount: Int {
        meals.filter { $0.status == .skipped }.count
    }

    // MARK: - Persistent Storage

    private func saveMeals() {

        do {

            let encoder = JSONEncoder()

            let data = try encoder.encode(meals)

            UserDefaults.standard.set(
                data,
                forKey: storageKey
            )

        } catch {

            print(
                "Meal saving failed: \(error.localizedDescription)"
            )
        }
    }

    private func loadMeals() {

        guard let data = UserDefaults.standard.data(
            forKey: storageKey
        ) else {
            meals = []
            return
        }

        do {

            let decoder = JSONDecoder()

            meals = try decoder.decode(
                [MealPlanItem].self,
                from: data
            )

        } catch {

            print(
                "Meal loading failed: \(error.localizedDescription)"
            )

            meals = []
        }
    }
}
