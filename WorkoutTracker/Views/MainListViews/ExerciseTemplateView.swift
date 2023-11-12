//
//  ExerciseTemplateView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-29.
//

import SwiftUI
import CoreData

struct ExerciseTemplateView: View {
    
    @EnvironmentObject private var viewModel: ExerciseTemplateViewModel
    @EnvironmentObject private var workoutViewModel: WorkoutTemplateViewModel
    @State private var isEditMode: EditMode = .inactive
    var workoutTemplate: WorkoutTemplateModel
    
    @State private var isShowingInputModal = false
    @State private var inputText = ""
    @State private var editableWorkoutName: String = ""

    var body: some View {
        VStack {
            HStack {
                    HStack(spacing: 0) {
                        Text("Exercises for ")
                            .font(.title)
                        InlineTextEditView(text: $editableWorkoutName)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(0)
                    }
                Spacer()
            }
            .onAppear(perform: {
                editableWorkoutName = workoutTemplate.type
            })
            .onChange(of: editableWorkoutName) { newValue in
                let newInfo = WorkoutTemplateInfo(type: newValue)
                workoutViewModel.update(workoutTemplate: workoutTemplate, withNewInfo: newInfo)
            }
            .padding(30)
            
            
            Button(action: {
                self.isShowingInputModal.toggle()
                
            }) {
                AddButton()
            }
            .background(Color.clear)
            .cornerRadius(30)
            .sheet(isPresented: $isShowingInputModal) {
                SimpleInputModalView(
                    inputText: $inputText,
                    isNameNotUnique: .constant(false),  // Always false as uniqueness is not required
                    onSubmit: {
                        viewModel.addExerciseTemplate(workoutTemplate: workoutTemplate, name: inputText)
                        viewModel.getExerciseTemplates(workoutTemplate: workoutTemplate)
                    },
                    isNameValid: { true }  // Always returns true, as uniqueness is not required
                )
            }

            
            if viewModel.exerciseTemplates.count == 0 {
                Text("No Exercises To Display")
                    .padding(.vertical, 20)
            }

            List {
                ForEach(viewModel.exerciseTemplates, id: \.id) { exercise in
                    ZStack {
                        ExerciseTemplateCard(type: exercise.name)
                    }
                }
                .onDelete(perform: deleteExercise)
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
        }
        .onChange(of: viewModel.exerciseTemplates.count) { newCount in
            if newCount == 0 && isEditMode == .active {
                isEditMode = .inactive
            }
        }
        .navigationBarItems(trailing: EditButton())
        .environment(\.editMode, $isEditMode)
        .onAppear(perform: {
            viewModel.getExerciseTemplates(workoutTemplate: workoutTemplate)
        })
        
    }
    func deleteExercise(at offsets: IndexSet) {
        offsets.forEach { index in
            let set = viewModel.exerciseTemplates[index] // get the set to be deleted
            viewModel.delete(set)
            viewModel.getExerciseTemplates(workoutTemplate: workoutTemplate)
            
        }
    }
}

struct ExerciseTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        
        let mockDataManager = DataManager(storeType: .inMemory)
        let mockDataController = ExerciseTemplateData(dataManager: mockDataManager)

        let entity = NSEntityDescription.entity(forEntityName: "WorkoutTemplate", in: mockDataManager.viewContext)!
        let workout = Workout(entity: entity, insertInto: mockDataManager.viewContext)
        workout.type = "Push"
        
        let mockDataWorkoutController = WorkoutTemplateData(dataManager: mockDataManager)
        let mockViewWorkoutModel = WorkoutTemplateViewModel(controller: mockDataWorkoutController)

        
        let mockViewModel = ExerciseTemplateViewModel(controller: mockDataController)
        return ExerciseListView(workout: WorkoutModel(workout: workout))
            .environmentObject(mockViewModel)
            .environmentObject(mockViewWorkoutModel)
    }
}