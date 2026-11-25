import Foundation
import Combine

@MainActor
final class MealPlannerStore: ObservableObject {

    // MARK: - Shared Meal Data

    @Published private(set) var meals: [MealPlanItem] = []

    private var currentUserEmail: String {
        let email = UserDefaults.standard.string(forKey: "loggedInEmail") ?? "default_user"
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return trimmed.isEmpty ? "default_user" : trimmed
    }

    private var storageKey: String {
        "MealMateSavedMeals_\(currentUserEmail)"
    }

    // MARK: - Initialization

    init() {
        loadMeals()
    }

    func reloadForCurrentUser() {
        loadMeals()
    }

    // MARK: - Add Meal

    @discardableResult
    func addMeal(_ meal: MealPlanItem) -> Bool {

        let cleanName = meal.dishName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanName.isEmpty else {
            return false
        }

        guard meal.servings > 0 else {
            return false
        }

        let selectedDate = Calendar.current.startOfDay(
            for: meal.date
        )

        var newMeal = meal
        newMeal.dishName = cleanName
        newMeal.date = selectedDate

        meals.append(newMeal)

        saveMeals()

        return true
    }

    // MARK: - Edit Meal

    @discardableResult
    func updateMeal(_ meal: MealPlanItem) -> Bool {

        guard let index = meals.firstIndex(
            where: { $0.id == meal.id }
        ) else {
            return false
        }

        let cleanName = meal.dishName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanName.isEmpty else {
            return false
        }

        guard meal.servings > 0 else {
            return false
        }

        let selectedDate = Calendar.current.startOfDay(
            for: meal.date
        )

        var updatedMeal = meal
        updatedMeal.dishName = cleanName
        updatedMeal.date = selectedDate

        meals[index] = updatedMeal

        saveMeals()

        return true
    }

    // MARK: - Update Meal Status

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

    // MARK: - Meals For Selected Date

    func meals(for date: Date) -> [MealPlanItem] {

        let target = Calendar.current.startOfDay(for: date)

        return meals
            .filter {
                Calendar.current.isDate(
                    $0.date,
                    inSameDayAs: target
                )
            }
            .sorted {
                mealOrder($0.mealType) <
                mealOrder($1.mealType)
            }
    }

    // MARK: - Weekly Meals

    func meals(forWeekContaining date: Date) -> [MealPlanItem] {

        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday

        let baseDate = calendar.startOfDay(for: date)

        guard let interval = calendar.dateInterval(
            of: .weekOfYear,
            for: baseDate
        ) else {
            return []
        }

        return meals
            .filter {
                $0.date >= interval.start &&
                $0.date < interval.end
            }
            .sorted {
                if $0.date == $1.date {
                    return mealOrder($0.mealType) <
                           mealOrder($1.mealType)
                }

                return $0.date < $1.date
            }
    }

    // MARK: - Meal Ordering

    private func mealOrder(_ type: String) -> Int {

        switch type {

        case "Breakfast":
            return 0

        case "Lunch":
            return 1

        case "Snacks":
            return 2

        case "Dinner":
            return 3

        default:
            return 4
        }
    }

    // MARK: - Dashboard Statistics

    var plannedCount: Int {
        meals.filter {
            $0.status == .planned
        }.count
    }

    var cookedCount: Int {
        meals.filter {
            $0.status == .cooked
        }.count
    }

    var skippedCount: Int {
        meals.filter {
            $0.status == .skipped
        }.count
    }

    // MARK: - Save Meals

    private func saveMeals() {

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(meals)

            // Save only to the active user's key so meals never leak across accounts
            UserDefaults.standard.set(data, forKey: storageKey)

        } catch {
            print("Meal saving failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Load Meals

    private func loadMeals() {

        let decoder = JSONDecoder()

        if let data = UserDefaults.standard.data(forKey: storageKey) {
            do {
                meals = try decoder.decode([MealPlanItem].self, from: data)
                return
            } catch {
                print("User meal decoding error: \(error)")
            }
        }

        meals = []
    }
}
