
import Foundation

// MARK: - Meal Status

enum MealPlanStatus: String, CaseIterable, Codable, Identifiable {
    case planned = "Planned"
    case cooked = "Cooked"
    case skipped = "Skipped"

    var id: String {
        rawValue
    }
}

// MARK: - Meal Type

enum MealType: String, CaseIterable, Codable, Identifiable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snacks = "Snacks"

    var id: String {
        rawValue
    }
}

// MARK: - Meal Model

struct MealPlanItem: Identifiable, Codable, Equatable {

    var id: UUID
    var dishName: String
    var date: Date
    var mealType: String
    var servings: Int
    var notes: String
    var status: MealPlanStatus
    var imageName: String

    init(
        id: UUID = UUID(),
        dishName: String,
        date: Date,
        mealType: String,
        servings: Int,
        notes: String = "",
        status: MealPlanStatus = .planned,
        imageName: String = "MealDefault"
    ) {
        self.id = id
        self.dishName = dishName
        self.date = Calendar.current.startOfDay(for: date)
        self.mealType = mealType
        self.servings = servings
        self.notes = notes
        self.status = status
        self.imageName = imageName
    }
}
