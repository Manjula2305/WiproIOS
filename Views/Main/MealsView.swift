import SwiftUI

struct MealsView: View {

    @EnvironmentObject private var store: MealPlannerStore

    @State private var selectedDate = Calendar.current.startOfDay(for: Date())
    @State private var selectedPeriod = "Today" // Defaults to Today, options: "Today", "Week"
    @State private var selectedMeal: MealPlanItem?
    @State private var mealToEdit: MealPlanItem?
    @State private var mealToDelete: MealPlanItem?
    @State private var showingDeleteAlert = false

    private let purple = Color(
        red: 0.43, green: 0.32, blue: 0.60
    )

    private let lavender = Color(
        red: 0.95, green: 0.92, blue: 0.98
    )

    // Compute the 7 days of the week containing selectedDate
    private var weekDates: [Date] {
        let calendar = Calendar.current
        let baseDate = calendar.startOfDay(for: selectedDate)

        let weekday = calendar.component(.weekday, from: baseDate)
        // Calendar weekday: 1 = Sun, 2 = Mon ... 7 = Sat.
        // We want Monday as start of week.
        let daysFromMonday = (weekday + 5) % 7

        let monday = calendar.date(
            byAdding: .day,
            value: -daysFromMonday,
            to: baseDate
        ) ?? baseDate

        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: monday)
        }
    }

    private var displayedMeals: [MealPlanItem] {
        if selectedPeriod == "Today" {
            return store.meals(for: selectedDate)
        } else {
            return store.meals(forWeekContaining: selectedDate)
        }
    }

    var body: some View {

        NavigationStack {

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 20) {

                    // Period Selector: Only "Today" and "Week"
                    periodSelector

                    // Date Navigator & Horizontal Day Picker
                    dateSelectorSection

                    // Section Header
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(selectedPeriod == "Today"
                                 ? "Meals for \(selectedDateFormatted)"
                                 : "Weekly Meal Plan")
                                .font(.system(size: 18, weight: .bold))

                            if selectedPeriod == "Today" && Calendar.current.isDateInToday(selectedDate) {
                                Text("Showing today's scheduled meals")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                            }
                        }

                        Spacer()

                        Text("\(displayedMeals.count) meals")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(purple)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(lavender)
                            .clipShape(Capsule())
                    }

                    // Meal List or Empty State
                    if displayedMeals.isEmpty {
                        emptyState
                    } else {
                        ForEach(displayedMeals, id: \.id) { meal in
                            mealCard(meal)
                        }
                    }
                }
                .padding(18)
                .padding(.bottom, 25)
            }
            .background(
                Color(red: 0.98, green: 0.97, blue: 0.99)
                    .ignoresSafeArea()
            )
            .navigationTitle("Meal Planner")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedMeal) { meal in
                NavigationStack {
                    MealDetailView(meal: meal)
                }
            }
            .sheet(item: $mealToEdit) { meal in
                EditMealView(meal: meal)
            }
            .alert(
                "Delete Meal?",
                isPresented: $showingDeleteAlert
            ) {
                Button("Delete", role: .destructive) {
                    if let meal = mealToDelete {
                        store.deleteMeal(meal)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this meal?")
            }
        }
    }

    private var selectedDateFormatted: String {
        if Calendar.current.isDateInToday(selectedDate) {
            return "Today"
        } else if Calendar.current.isDateInTomorrow(selectedDate) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(selectedDate) {
            return "Yesterday"
        }
        return selectedDate.formatted(.dateTime.month(.abbreviated).day())
    }

    // MARK: - Period Selector (Only Today and Week)

    private var periodSelector: some View {

        HStack(spacing: 6) {

            ForEach(["Today", "Week"], id: \.self) { period in

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedPeriod = period
                        if period == "Today" && !Calendar.current.isDateInToday(selectedDate) {
                            selectedDate = Calendar.current.startOfDay(for: Date())
                        }
                    }
                } label: {

                    Text(period)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(
                            selectedPeriod == period ? .white : purple
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            selectedPeriod == period ? purple : .clear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(5)
        .background(lavender)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Date Selector Section

    private var dateSelectorSection: some View {

        VStack(alignment: .leading, spacing: 12) {

            // Month / Year title and week navigation
            HStack {

                VStack(alignment: .leading, spacing: 2) {
                    Text(selectedDate.formatted(
                        .dateTime.month(.wide).year()
                    ))
                    .font(.system(size: 17, weight: .bold))

                    Text(selectedDate.formatted(date: .complete, time: .omitted))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Compact Date Picker button allowing picking ANY date directly
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(purple)

                // Previous week button
                Button {
                    shiftDate(byDays: -7)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(purple)
                        .padding(8)
                        .background(lavender)
                        .clipShape(Circle())
                }

                // Next week button
                Button {
                    shiftDate(byDays: 7)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(purple)
                        .padding(8)
                        .background(lavender)
                        .clipShape(Circle())
                }
            }

            // Horizontal week strip adapted dynamically to selectedDate
            HStack(spacing: 7) {

                ForEach(weekDates, id: \.self) { date in

                    let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                    let isToday = Calendar.current.isDateInToday(date)

                    Button {
                        withAnimation {
                            selectedDate = date
                        }
                    } label: {

                        VStack(spacing: 5) {

                            Text(date.formatted(.dateTime.weekday(.narrow)))
                                .font(.system(size: 11, weight: .semibold))

                            Text(date.formatted(.dateTime.day()))
                                .font(.system(size: 13, weight: .bold))

                            if isToday {
                                Circle()
                                    .fill(isSelected ? Color.white : purple)
                                    .frame(width: 4, height: 4)
                            } else {
                                Spacer()
                                    .frame(height: 4)
                            }
                        }
                        .foregroundColor(isSelected ? .white : purple)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(isSelected ? purple : lavender)
                        .clipShape(RoundedRectangle(cornerRadius: 11))
                    }
                }
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func shiftDate(byDays days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            withAnimation {
                selectedDate = newDate
            }
        }
    }

    // MARK: - Meal Card

    private func mealCard(_ meal: MealPlanItem) -> some View {

        Button {
            selectedMeal = meal
        } label: {

            HStack(spacing: 12) {

                mealImage(meal.imageName)

                VStack(alignment: .leading, spacing: 6) {

                    Text(meal.dishName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)

                    Text("\(meal.mealType) · \(meal.servings) servings")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)

                    Text(meal.date.formatted(
                        .dateTime.weekday(.abbreviated).day().month(.abbreviated)
                    ))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(purple)

                    statusBadge(meal.status)
                }

                Spacer()

                // Quick Edit button on the card
                Button {
                    mealToEdit = meal
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(purple)
                }
                .buttonStyle(.borderless)

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                mealToEdit = meal
            } label: {
                Label("Edit Meal", systemImage: "pencil")
            }

            Button(role: .destructive) {
                mealToDelete = meal
                showingDeleteAlert = true
            } label: {
                Label("Delete Meal", systemImage: "trash")
            }
        }
    }

    private func mealImage(_ name: String) -> some View {
        FoodThumbnailView(
            imageName: name,
            size: 72,
            fontSize: 36,
            cornerRadius: 11
        )
    }

    private func statusBadge(_ status: MealPlanStatus) -> some View {

        Text(status.rawValue)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(purple)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(lavender)
            .clipShape(Capsule())
    }

    // MARK: - Empty State

    private var emptyState: some View {

        VStack(spacing: 12) {

            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 40))
                .foregroundColor(purple)

            Text("No meals planned")
                .font(.system(size: 16, weight: .semibold))

            Text(selectedPeriod == "Today"
                 ? "No meals found for \(selectedDate.formatted(date: .complete, time: .omitted)). Add a meal from the Add tab!"
                 : "No meals found for this week. Tap Add to plan meals.")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(35)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
