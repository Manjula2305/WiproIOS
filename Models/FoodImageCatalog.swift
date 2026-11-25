import SwiftUI

struct FoodImageOption: Identifiable, Hashable {
    let id: String
    let name: String
    let category: String
    let systemIcon: String
    let emoji: String
    let color: Color
}

struct FoodImageCatalog {
    static let categories: [String] = ["Breakfast", "Lunch", "Dinner", "Snacks", "Fruits"]

    static let allFoods: [FoodImageOption] = [
        // ==================== 🌅 BREAKFAST (Tamil & English) ====================
        FoodImageOption(id: "dosa", name: "Dosa", category: "Breakfast", systemIcon: "fork.knife", emoji: "🥞", color: Color(red: 0.92, green: 0.65, blue: 0.28)),
        FoodImageOption(id: "idli", name: "Idli & Sambar", category: "Breakfast", systemIcon: "fork.knife", emoji: "⚪️", color: Color(red: 0.88, green: 0.72, blue: 0.40)),
        FoodImageOption(id: "poori", name: "Poori Masala", category: "Breakfast", systemIcon: "fork.knife", emoji: "🫓", color: Color(red: 0.95, green: 0.70, blue: 0.30)),
        FoodImageOption(id: "pongal", name: "Ven Pongal", category: "Breakfast", systemIcon: "fork.knife", emoji: "🍚", color: Color(red: 0.90, green: 0.80, blue: 0.40)),
        FoodImageOption(id: "kuzhi_paniyaram", name: "Kuzhi Paniyaram", category: "Breakfast", systemIcon: "fork.knife", emoji: "🧆", color: Color(red: 0.82, green: 0.58, blue: 0.32)),
        FoodImageOption(id: "vada", name: "Medu Vada", category: "Breakfast", systemIcon: "fork.knife", emoji: "🥯", color: Color(red: 0.86, green: 0.58, blue: 0.26)),
        FoodImageOption(id: "appam", name: "Appam & Coconut Milk", category: "Breakfast", systemIcon: "fork.knife", emoji: "🍳", color: Color(red: 0.92, green: 0.78, blue: 0.48)),
        FoodImageOption(id: "upma", name: "Rava Upma", category: "Breakfast", systemIcon: "fork.knife", emoji: "🍲", color: Color(red: 0.88, green: 0.75, blue: 0.42)),
        FoodImageOption(id: "bread", name: "Bread & Butter", category: "Breakfast", systemIcon: "fork.knife", emoji: "🍞", color: Color(red: 0.85, green: 0.65, blue: 0.40)),
        FoodImageOption(id: "toast", name: "French Toast", category: "Breakfast", systemIcon: "fork.knife", emoji: "🥪", color: Color(red: 0.90, green: 0.70, blue: 0.45)),
        FoodImageOption(id: "pancakes", name: "English Pancakes", category: "Breakfast", systemIcon: "fork.knife", emoji: "🥞", color: Color(red: 0.95, green: 0.78, blue: 0.42)),
        FoodImageOption(id: "waffles", name: "Waffles", category: "Breakfast", systemIcon: "fork.knife", emoji: "🧇", color: Color(red: 0.92, green: 0.72, blue: 0.40)),
        FoodImageOption(id: "croissant", name: "Croissant", category: "Breakfast", systemIcon: "fork.knife", emoji: "🥐", color: Color(red: 0.88, green: 0.68, blue: 0.38)),
        FoodImageOption(id: "boiled_egg", name: "Eggs & Omelette", category: "Breakfast", systemIcon: "fork.knife", emoji: "🍳", color: Color(red: 0.98, green: 0.80, blue: 0.30)),
        FoodImageOption(id: "english_breakfast", name: "Full English Breakfast", category: "Breakfast", systemIcon: "fork.knife", emoji: "🥓", color: Color(red: 0.80, green: 0.40, blue: 0.30)),

        // ==================== 🍛 LUNCH (Tamil & English) ====================
        FoodImageOption(id: "south_indian_meals", name: "South Indian Meals (Thali)", category: "Lunch", systemIcon: "fork.knife", emoji: "🍱", color: Color(red: 0.45, green: 0.70, blue: 0.40)),
        FoodImageOption(id: "biryani", name: "Dum Biryani", category: "Lunch", systemIcon: "fork.knife", emoji: "🍛", color: Color(red: 0.88, green: 0.46, blue: 0.20)),
        FoodImageOption(id: "sambar_rice", name: "Sambar Rice", category: "Lunch", systemIcon: "fork.knife", emoji: "🍲", color: Color(red: 0.88, green: 0.55, blue: 0.25)),
        FoodImageOption(id: "curd_rice", name: "Curd Rice", category: "Lunch", systemIcon: "fork.knife", emoji: "🍚", color: Color(red: 0.65, green: 0.80, blue: 0.75)),
        FoodImageOption(id: "rasam_rice", name: "Rasam Rice", category: "Lunch", systemIcon: "fork.knife", emoji: "🥣", color: Color(red: 0.90, green: 0.50, blue: 0.25)),
        FoodImageOption(id: "fish_curry_meals", name: "Fish Curry Meals", category: "Lunch", systemIcon: "fork.knife", emoji: "🐟", color: Color(red: 0.80, green: 0.42, blue: 0.28)),
        FoodImageOption(id: "chicken_biryani", name: "Chicken Biryani", category: "Lunch", systemIcon: "fork.knife", emoji: "🍗", color: Color(red: 0.85, green: 0.40, blue: 0.22)),
        FoodImageOption(id: "fried_rice", name: "Fried Rice", category: "Lunch", systemIcon: "fork.knife", emoji: "🥡", color: Color(red: 0.88, green: 0.65, blue: 0.30)),
        FoodImageOption(id: "pasta_lunch", name: "Creamy Pasta", category: "Lunch", systemIcon: "fork.knife", emoji: "🍝", color: Color(red: 0.90, green: 0.40, blue: 0.30)),
        FoodImageOption(id: "grilled_chicken", name: "Grilled Chicken Steak", category: "Lunch", systemIcon: "fork.knife", emoji: "🍖", color: Color(red: 0.78, green: 0.35, blue: 0.22)),
        FoodImageOption(id: "lunch_salad", name: "Caesar Salad", category: "Lunch", systemIcon: "leaf.fill", emoji: "🥗", color: Color(red: 0.35, green: 0.70, blue: 0.40)),

        // ==================== 🌙 DINNER (Tamil & English) ====================
        FoodImageOption(id: "parotta", name: "Parotta & Salna", category: "Dinner", systemIcon: "fork.knife", emoji: "🫓", color: Color(red: 0.87, green: 0.66, blue: 0.35)),
        FoodImageOption(id: "chappathi", name: "Chapati & Dal", category: "Dinner", systemIcon: "fork.knife", emoji: "🫓", color: Color(red: 0.85, green: 0.68, blue: 0.42)),
        FoodImageOption(id: "dosa_dinner", name: "Crispy Roast Dosa", category: "Dinner", systemIcon: "fork.knife", emoji: "🥞", color: Color(red: 0.90, green: 0.60, blue: 0.25)),
        FoodImageOption(id: "paneer_butter", name: "Paneer Butter Masala & Naan", category: "Dinner", systemIcon: "fork.knife", emoji: "🥘", color: Color(red: 0.90, green: 0.45, blue: 0.22)),
        FoodImageOption(id: "idiyappam", name: "Idiyappam & Kurma", category: "Dinner", systemIcon: "fork.knife", emoji: "🍜", color: Color(red: 0.82, green: 0.75, blue: 0.50)),
        FoodImageOption(id: "noodles_dinner", name: "Noodles / Ramen", category: "Dinner", systemIcon: "fork.knife", emoji: "🍜", color: Color(red: 0.88, green: 0.55, blue: 0.25)),
        FoodImageOption(id: "pizza_dinner", name: "Italian Pizza", category: "Dinner", systemIcon: "fork.knife", emoji: "🍕", color: Color(red: 0.90, green: 0.42, blue: 0.28)),
        FoodImageOption(id: "burger_dinner", name: "Burger & Patties", category: "Dinner", systemIcon: "fork.knife", emoji: "🍔", color: Color(red: 0.85, green: 0.50, blue: 0.25)),
        FoodImageOption(id: "soup_dinner", name: "Hot Vegetable Soup", category: "Dinner", systemIcon: "fork.knife", emoji: "🍲", color: Color(red: 0.80, green: 0.50, blue: 0.30)),

        // ==================== ☕️ SNACKS (Tamil & English) ====================
        FoodImageOption(id: "samosa", name: "Samosa", category: "Snacks", systemIcon: "fork.knife", emoji: "🥟", color: Color(red: 0.88, green: 0.60, blue: 0.25)),
        FoodImageOption(id: "bajji", name: "Bajji / Pakora", category: "Snacks", systemIcon: "fork.knife", emoji: "🧆", color: Color(red: 0.90, green: 0.58, blue: 0.22)),
        FoodImageOption(id: "bonda", name: "Mysore Bonda", category: "Snacks", systemIcon: "fork.knife", emoji: "🍘", color: Color(red: 0.85, green: 0.55, blue: 0.25)),
        FoodImageOption(id: "filter_coffee", name: "South Indian Filter Coffee", category: "Snacks", systemIcon: "cup.and.saucer.fill", emoji: "☕️", color: Color(red: 0.55, green: 0.38, blue: 0.28)),
        FoodImageOption(id: "masala_chai", name: "Masala Tea / Chai", category: "Snacks", systemIcon: "cup.and.saucer.fill", emoji: "🫖", color: Color(red: 0.70, green: 0.45, blue: 0.30)),
        FoodImageOption(id: "sandwich_snack", name: "Club Sandwich", category: "Snacks", systemIcon: "fork.knife", emoji: "🥪", color: Color(red: 0.85, green: 0.65, blue: 0.40)),
        FoodImageOption(id: "french_fries", name: "French Fries", category: "Snacks", systemIcon: "fork.knife", emoji: "🍟", color: Color(red: 0.92, green: 0.72, blue: 0.30)),
        FoodImageOption(id: "cake_snack", name: "Cake Pastry", category: "Snacks", systemIcon: "birthday.cake.fill", emoji: "🍰", color: Color(red: 0.92, green: 0.55, blue: 0.65)),
        FoodImageOption(id: "cookie_snack", name: "Cookies & Biscuits", category: "Snacks", systemIcon: "circle.fill", emoji: "🍪", color: Color(red: 0.78, green: 0.55, blue: 0.35)),
        FoodImageOption(id: "donut_snack", name: "Donut", category: "Snacks", systemIcon: "circle.circle", emoji: "🍩", color: Color(red: 0.85, green: 0.55, blue: 0.45)),
        FoodImageOption(id: "icecream_snack", name: "Ice Cream", category: "Snacks", systemIcon: "cup.and.saucer.fill", emoji: "🍨", color: Color(red: 0.70, green: 0.60, blue: 0.85)),

        // ==================== 🍎 FRUITS ====================
        FoodImageOption(id: "apple", name: "Fresh Apple", category: "Fruits", systemIcon: "leaf.fill", emoji: "🍎", color: Color(red: 0.90, green: 0.30, blue: 0.30)),
        FoodImageOption(id: "banana", name: "Banana", category: "Fruits", systemIcon: "leaf.fill", emoji: "🍌", color: Color(red: 0.92, green: 0.78, blue: 0.25)),
        FoodImageOption(id: "mango", name: "Mango", category: "Fruits", systemIcon: "leaf.fill", emoji: "🥭", color: Color(red: 0.96, green: 0.65, blue: 0.20)),
        FoodImageOption(id: "orange", name: "Orange", category: "Fruits", systemIcon: "leaf.fill", emoji: "🍊", color: Color(red: 0.95, green: 0.55, blue: 0.20)),
        FoodImageOption(id: "grapes", name: "Grapes", category: "Fruits", systemIcon: "leaf.fill", emoji: "🍇", color: Color(red: 0.60, green: 0.35, blue: 0.75)),
        FoodImageOption(id: "watermelon", name: "Watermelon", category: "Fruits", systemIcon: "leaf.fill", emoji: "🍉", color: Color(red: 0.88, green: 0.32, blue: 0.40)),
        FoodImageOption(id: "strawberry", name: "Strawberry", category: "Fruits", systemIcon: "leaf.fill", emoji: "🍓", color: Color(red: 0.90, green: 0.28, blue: 0.35)),
        FoodImageOption(id: "pineapple", name: "Pineapple", category: "Fruits", systemIcon: "leaf.fill", emoji: "🍍", color: Color(red: 0.92, green: 0.70, blue: 0.22))
    ]

    static func option(for id: String) -> FoodImageOption? {
        allFoods.first(where: { $0.id == id })
    }

    static func emoji(for id: String) -> String? {
        allFoods.first(where: { $0.id == id })?.emoji
    }
}

struct FoodThumbnailView: View {
    let imageName: String
    var size: CGFloat = 60
    var fontSize: CGFloat = 30
    var cornerRadius: CGFloat = 12

    private var option: FoodImageOption? {
        FoodImageCatalog.option(for: imageName)
    }

    var body: some View {
        ZStack {
            if !imageName.isEmpty, let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipped()
            } else if let opt = option {
                opt.color.opacity(0.18)
                Text(opt.emoji)
                    .font(.system(size: fontSize))
            } else {
                Color.purple.opacity(0.12)
                Image(systemName: "photo.badge.plus")
                    .font(.system(size: fontSize * 0.65))
                    .foregroundColor(Color(red: 0.43, green: 0.32, blue: 0.60))
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
