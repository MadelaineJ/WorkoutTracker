//
//  ExerciseTemplateListView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2024-02-13.
//

import SwiftUI



struct ExerciseTemplateListView: View {
    
    @EnvironmentObject private var viewModel: ExerciseTemplateViewModel
    @EnvironmentObject private var workoutViewModel: WorkoutTemplateViewModel
    
    @State private var isShowingInputModal = false
    @State private var isNameNotUnique = false
    @State private var showingDeleteAlert = false
    @State private var isEditMode: EditMode = .inactive
    @State private var inputText = ""
    @State private var navigationPath = NavigationPath()
    @State private var sortOption: SortOption = .az // Default sorting option
    
    enum SortOption {
        case az, za, newest, oldest

        var displayName: String {
            switch self {
            case .az:
                return "A-Z"
            case .za:
                return "Z-A"
            case .newest:
                return "Newest"
            case .oldest:
                return "Oldest"
            }
        }
    }
    
    var sortedExerciseTemplates: [ExerciseTemplateModel] {
        switch sortOption {
        case .az:
            return viewModel.exerciseTemplates.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        case .za:
            return viewModel.exerciseTemplates.sorted(by: { $0.name.lowercased() > $1.name.lowercased() })
        case .newest:
            return viewModel.exerciseTemplates.sorted(by: { $0.creationDate > $1.creationDate })
        case .oldest:
            return viewModel.exerciseTemplates.sorted(by: { $0.creationDate < $1.creationDate })
        }
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            
            VStack {
                
                HStack {
                    Text("Exercise Templates")
                        .font(.title)
                    Spacer()
                    // Sort button

                }
                .padding(.horizontal, 30)
                
                Button(action: {
                    self.isShowingInputModal.toggle()
                }) {
                    AddButton()
                }
                .background(Color.clear)
                .cornerRadius(30)
                .sheet(isPresented: $isShowingInputModal) {
                    SimpleInputModalView(inputText: $inputText, isNameNotUnique: $isNameNotUnique, onSubmit: {
                        _ = ExerciseTemplateModel(exercise: viewModel.createExerciseTemplate(name: inputText))
                    }, isNameValid: isTemplateNameUnique)
                }
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("Unable to Delete Exercise Template"),
                        message: Text("This exercise template is being used by a workout template. \n You are unable to delete it.")
                    )
                }
                
                HStack() {
                    Menu {
                        Button("A-Z", action: { sortOption = .az })
                        Button("Z-A", action: { sortOption = .za })
                        Button("Newest", action: { sortOption = .newest })
                        Button("Oldest", action: { sortOption = .oldest })
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                            Text(sortOption.displayName) // Use sortOption directly
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 20)

                    Spacer()
                    Text("\(sortedExerciseTemplates.count) templates")
                        .padding(.horizontal, 25)
                }


                List {
                    ForEach(sortedExerciseTemplates, id: \.self) { exercise in
                        Text(exercise.name)
                            .padding(.vertical, 8)
                    }
                    .onDelete(perform: deleteExerciseTemplate)
//                      .listRowSeparator(.hidden)
//                    .listSectionSeparator(.hidden, edges: .all)
                    
                }
                .listStyle(PlainListStyle())
                .navigationBarItems(trailing: EditButton())
                .onAppear() {
                    viewModel.getAllExerciseTemplates()
                    isEditMode = .inactive
                }
                .onChange(of: viewModel.exerciseTemplates.count) { newCount in
                    if newCount == 0 && isEditMode == .active {
                        isEditMode = .inactive
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    func deleteExerciseTemplate(at offsets: IndexSet) {
        offsets.forEach { offset in
            // Find the exercise template in the sorted list.
            let exerciseToDelete = sortedExerciseTemplates[offset]
            
            // Now find this exercise template's index in the original viewModel.exerciseTemplates array.
            if let indexInOriginal = viewModel.exerciseTemplates.firstIndex(where: { $0.id == exerciseToDelete.id }) {
                let exercise = viewModel.exerciseTemplates[indexInOriginal] // get the item to be deleted from the original array
                
                // Check if it can be deleted.
                if viewModel.checkDelete(exerciseTemplate: exercise) {
                    viewModel.delete(exercise)
                    viewModel.getAllExerciseTemplates() // Refresh data
                } else {
                    showingDeleteAlert = true
                }
            }
        }
    }

    
    func isTemplateNameUnique() -> Bool {
        let isUnique = !viewModel.exerciseTemplates.contains(where: { $0.name.lowercased() == inputText.lowercased() })
        isNameNotUnique = !isUnique  // Set the state variable based on uniqueness
        return isUnique
    }
    
    
}

#Preview {
    ExerciseTemplateListView()
}
