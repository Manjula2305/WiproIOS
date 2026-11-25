import SwiftUI

struct FoodImagePickerView: View {
    @Binding var selectedImageName: String
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var selectedCategory = "All"

    private let purple = Color(
        red: 0.43,
        green: 0.32,
        blue: 0.60
    )

    private let lavender = Color(
        red: 0.95,
        green: 0.92,
        blue: 0.98
    )

    private var categories: [String] {
        var cats = ["All"]
        cats.append(contentsOf: FoodImageCatalog.categories)
        return cats
    }

    private var filteredFoods: [FoodImageOption] {
        var list = FoodImageCatalog.allFoods
        if selectedCategory != "All" {
            list = list.filter { $0.category == selectedCategory }
        }
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !q.isEmpty {
            list = list.filter { $0.name.lowercased().contains(q) || $0.category.lowercased().contains(q) }
        }
        return list
    }

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                // Search Bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(purple)
                    TextField("Search food (e.g., Bread, Pizza, Rice)", text: $searchText)
                        .font(.system(size: 14))
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
                .padding(.top, 10)

                // Category Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            Button {
                                selectedCategory = cat
                            } label: {
                                Text(cat)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(selectedCategory == cat ? .white : purple)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(selectedCategory == cat ? purple : lavender)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                // Grid of food images
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(filteredFoods) { food in
                            let isSelected = selectedImageName == food.id

                            Button {
                                selectedImageName = food.id
                                dismiss()
                            } label: {
                                VStack(spacing: 8) {
                                    ZStack {
                                        food.color.opacity(0.18)

                                        Text(food.emoji)
                                            .font(.system(size: 42))

                                        if isSelected {
                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(purple)
                                                        .background(Circle().fill(Color.white))
                                                        .font(.system(size: 20))
                                                }
                                                Spacer()
                                            }
                                            .padding(6)
                                        }
                                    }
                                    .frame(height: 85)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(isSelected ? purple : Color.clear, lineWidth: 2.5)
                                    }

                                    Text(food.name)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                }
                                .padding(8)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: Color.black.opacity(0.04), radius: 4, y: 2)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(16)
                }
            }
            .background(Color(red: 0.98, green: 0.97, blue: 0.99).ignoresSafeArea())
            .navigationTitle("Choose Food Image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(purple)
                }
            }
        }
    }
}
