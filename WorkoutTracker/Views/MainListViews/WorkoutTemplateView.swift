//
//  WorkoutTemplateView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-29.
//

import SwiftUI

struct WorkoutTemplateView: View {
    @EnvironmentObject private var viewModel: WorkoutTemplateViewModel
    @EnvironmentObject private var exerciseViewModel: ExerciseTemplateViewModel
    
    @State private var isShowingInputModal = false
    @State private var inputText = ""
    @State private var isNameNotUnique = false
    @State private var isEditMode: EditMode = .inactive
    @State private var navigateToExerciseList = false
    @State private var selectedWorkoutTemplate: WorkoutTemplateModel?
    @State private var navigationPath = NavigationPath()

    let cardHeight: CGFloat = 150 // Fixed vertical size for each card

    private var gridLayout: [GridItem] = Array(repeating: .init(.flexible(), spacing: 20), count: 2)

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                HStack {
                    Text("Workout Templates")
                        .font(.title)
                        .padding(.top, 39)
                    Spacer()
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
                        if let newWorkout = viewModel.createWorkoutTemplate(type: inputText) {
                            viewModel.getAllWorkoutTemplates()
                            isNameNotUnique = false
                            let newWorkoutTemplate = WorkoutTemplateModel(workout: newWorkout)
                            navigationPath.append(newWorkoutTemplate)
                        }
                    }, isNameValid: isTemplateNameUnique)
                }
                
                if viewModel.workoutTemplates.count > 0 {
                    ScrollView() {
                        LazyVGrid(columns: gridLayout, spacing: 55) {
                            ForEach(viewModel.workoutTemplates, id: \.id) { workout in
                                TemplateCard(type: workout.type, exercises: viewModel.getExercisesForWorkout(workoutTemplate: workout),
                                             colour: Color(viewModel.getColorForWorkoutTemplate(workoutTemplateId: workout.id) ?? .systemGray6))
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                                    .onTapGesture {
                                        navigationPath.append(workout)
                                    }
                            }
                        }
                        .padding(.top, 40)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 25)
                    .onAppear(perform: {
                        viewModel.getAllWorkoutTemplates()
                    })
                } else {
                    Text("No Workout Templates")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationDestination(for: WorkoutTemplateModel.self) { workoutTemplate in
                ExerciseTemplateView(workoutTemplate: workoutTemplate, editableWorkoutName: workoutTemplate.type, navigationPath: $navigationPath)
            }
            .onChange(of: viewModel.workoutTemplates.count) { newCount in
                if newCount == 0 && isEditMode == .active {
                    isEditMode = .inactive
                }
            }
            .onAppear(perform: {
                viewModel.getAllWorkoutTemplates()
            })
        }
        .background(Color(.white))
    }
    func isTemplateNameUnique() -> Bool {
        let isUnique = !viewModel.workoutTemplates.contains(where: { $0.type.lowercased() == inputText.lowercased() })
        isNameNotUnique = !isUnique  // Set the state variable based on uniqueness
        return isUnique
    }
    
    func deleteWorkout(at offsets: IndexSet) {
        offsets.forEach { index in
            guard viewModel.workoutTemplates.indices.contains(index) else { return } // Safely check if the index is valid
            
            let workout = viewModel.workoutTemplates[index] // get the set to be deleted
            viewModel.delete(workout)
            
            viewModel.getAllWorkoutTemplates()
        }
    }
}

struct TemplateView_Previews: PreviewProvider {
    static var previews: some View {
        let mockDataManager = DataManager(storeType: .inMemory)
        
        let mockDataWorkoutController = WorkoutTemplateData(dataManager: mockDataManager)
        let mockViewWorkoutModel = WorkoutTemplateViewModel(controller: mockDataWorkoutController)
        
        
        return WorkoutTemplateView()
            .environmentObject(mockViewWorkoutModel)
    }
}
