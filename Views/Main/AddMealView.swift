import SwiftUI

struct AddMealView: View {

    @EnvironmentObject private var store: MealPlannerStore
    var onMealSaved: (() -> Void)? = nil

    @State private var dishName: String = ""
    @State private var selectedType: MealType = .breakfast
    @State private var selectedImageName: String = ""
    @State private var showingImagePicker = false
    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var showingDatePicker = false
    @State private var servings: Int = 1
    @State private var notes: String = ""

    @State private var lastSavedDishName = ""
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

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 20) {

                    imageSelectionSection

                    dishNameSection

                    mealTypeSection

                    dateSection

                    servingsSection

                    notesSection
                }
                .padding(20)
                .padding(.bottom, 25)
            }
            .background(
                Color(
                    red: 0.98,
                    green: 0.97,
                    blue: 0.99
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Add Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        resetForm()
                    }
                    .foregroundColor(purple)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMeal()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(purple)
                }
            }

            .alert("Saved Successfully", isPresented: $showingSuccess) {
                Button("OK", role: .cancel) {
                    resetForm()
                    onMealSaved?()
                }
            } message: { }

            .alert("Unable to Save", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid dish name and select valid servings.")
            }
        }
    }

    // MARK: - Success Popup Banner

    private var successBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title2)

            Text("Saved Successfully")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.12), radius: 8, y: 3)
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

            TextField(
                "Enter dish name",
                text: $dishName
            )
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

    // MARK: - Date Selection

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

            Stepper(
                "\(servings) Servings",
                value: $servings,
                in: 1...20
            )
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

            saveMeal()

        } label: {

            HStack {

                Image(systemName: "checkmark.circle.fill")

                Text("Save Meal")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(purple)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Section Title

    private func sectionTitle(
        _ title: String,
        icon: String
    ) -> some View {

        Label(title, systemImage: icon)
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(purple)
    }

    // MARK: - Save Logic

    private func saveMeal() {

        let cleanName = dishName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanName.isEmpty else {
            showingError = true
            return
        }

        let meal = MealPlanItem(
            dishName: cleanName,
            date: selectedDate,
            mealType: selectedType.rawValue,
            servings: servings,
            notes: notes,
            status: .planned,
            imageName: selectedImageName
        )

        if store.addMeal(meal) {
            lastSavedDishName = cleanName
            showingSuccess = true
        } else {
            showingError = true
        }
    }

    // MARK: - Reset Form

    private func resetForm() {
        dishName = ""
        selectedType = .breakfast
        selectedImageName = ""
        selectedDate = Calendar.current.startOfDay(for: Date())
        servings = 1
        notes = ""
    }
}
