import SwiftUI

struct EditMealView: View {

    @EnvironmentObject private var store: MealPlannerStore
    @Environment(\.dismiss) private var dismiss

    let meal: MealPlanItem
    var onMealUpdated: (() -> Void)? = nil

    @State private var dishName: String
    @State private var selectedType: MealType
    @State private var selectedImageName: String
    @State private var showingImagePicker = false
    @State private var selectedDate: Date
    @State private var showingDatePicker = false
    @State private var servings: Int
    @State private var status: MealPlanStatus
    @State private var notes: String

    @State private var showingSuccess = false
    @State private var showingError = false

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

    init(meal: MealPlanItem, onMealUpdated: (() -> Void)? = nil) {
        self.meal = meal
        self.onMealUpdated = onMealUpdated
        _dishName = State(initialValue: meal.dishName)
        _selectedType = State(initialValue: MealType(rawValue: meal.mealType) ?? .lunch)
        _selectedImageName = State(initialValue: meal.imageName.isEmpty ? "bread" : meal.imageName)
        _selectedDate = State(initialValue: meal.date)
        _servings = State(initialValue: meal.servings)
        _status = State(initialValue: meal.status)
        _notes = State(initialValue: meal.notes)
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 20) {

                    imageSelectionSection

                    dishNameSection

                    mealTypeSection

                    statusSection

                    dateSection

                    servingsSection

                    notesSection
                }
                .padding(20)
                .padding(.bottom, 25)
            }
            .background(
                Color(red: 0.98, green: 0.97, blue: 0.99)
                    .ignoresSafeArea()
            )
            .navigationTitle("Edit Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(purple)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(purple)
                }
            }
            .alert("Saved Successfully", isPresented: $showingSuccess) {
                Button("OK", role: .cancel) {
                    dismiss()
                    onMealUpdated?()
                }
            } message: { }
            .alert("Unable to Save", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid dish name and select valid servings.")
            }
        }
    }

    // MARK: - Image Selection Section

    private var imageSelectionSection: some View {

        Button {
            showingImagePicker = true
        } label: {
            HStack(spacing: 14) {
                FoodThumbnailView(
                    imageName: selectedImageName,
                    size: 65,
                    fontSize: 34,
                    cornerRadius: 14
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(
                        selectedImageName.isEmpty
                        ? "Choose Meal"
                        : (FoodImageCatalog.option(for: selectedImageName)?.name ?? "Selected Meal")
                    )
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(selectedImageName.isEmpty ? purple : .primary)

                    Text(
                        selectedImageName.isEmpty
                        ? "Tap to select your favorite dish"
                        : "Tap to change meal"
                    )
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding(12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingImagePicker) {
            FoodImagePickerView(selectedImageName: $selectedImageName)
        }
    }

    // MARK: - Dish Name

    private var dishNameSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            sectionTitle("Dish Name", icon: "fork.knife")

            TextField("Enter dish name", text: $dishName)
                .padding(15)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Meal Type

    private var mealTypeSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            sectionTitle("Meal Type", icon: "clock")

            Picker("Meal Type", selection: $selectedType) {

                ForEach(MealType.allCases) { type in

                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .pickerStyle(.menu)
            .tint(purple)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Status

    private var statusSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            sectionTitle("Meal Status", icon: "checkmark.circle")

            Picker("Status", selection: $status) {

                ForEach(MealPlanStatus.allCases, id: \.self) { s in

                    Text(s.rawValue)
                        .tag(s)
                }
            }
            .pickerStyle(.segmented)
            .padding(4)
            .background(lavender)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    // MARK: - Date Section

    private var dateSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            sectionTitle("Choose Date", icon: "calendar")

            Button {
                showingDatePicker = true
            } label: {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(purple)

                    Text(selectedDate.formatted(date: .complete, time: .omitted))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(14)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $showingDatePicker) {
            NavigationStack {
                VStack(spacing: 20) {
                    DatePicker(
                        "Meal Date",
                        selection: Binding(
                            get: { selectedDate },
                            set: { newDate in
                                selectedDate = Calendar.current.startOfDay(for: newDate)
                                showingDatePicker = false
                            }
                        ),
                        in: Calendar.current.startOfDay(for: Date())...,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .tint(purple)
                    .padding()

                    Spacer()
                }
                .navigationTitle("Select Date")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            showingDatePicker = false
                        }
                        .foregroundColor(purple)
                        .fontWeight(.bold)
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }

    // MARK: - Servings

    private var servingsSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            sectionTitle("Number of Servings", icon: "person.2")

            Stepper("\(servings) Servings", value: $servings, in: 1...20)
                .padding(15)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Notes

    private var notesSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            sectionTitle("Notes & Ingredients", icon: "note.text")

            TextEditor(text: $notes)
                .frame(height: 90)
                .padding(8)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Save Button

    private var saveButton: some View {

        Button {
            saveChanges()
        } label: {

            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Save Changes")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(purple)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private func sectionTitle(_ title: String, icon: String) -> some View {

        Label(title, systemImage: icon)
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(purple)
    }

    // MARK: - Save Logic

    private func saveChanges() {

        let cleanName = dishName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanName.isEmpty else {
            showingError = true
            return
        }

        var updated = meal
        updated.dishName = cleanName
        updated.mealType = selectedType.rawValue
        updated.imageName = selectedImageName
        updated.date = selectedDate
        updated.servings = servings
        updated.status = status
        updated.notes = notes

        if store.updateMeal(updated) {
            showingSuccess = true
        } else {
            showingError = true
        }
    }
}
