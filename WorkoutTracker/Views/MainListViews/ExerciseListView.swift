//
//  WorkoutDetails.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-14.
//

import SwiftUI
import CoreData

struct ExerciseListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var viewModel: ExerciseViewModel
    @EnvironmentObject private var workoutViewModel: WorkoutViewModel
    
    var workout: WorkoutModel
    
    @State private var isShowingInputModal = false
    @State private var inputText = ""
    @State private var editableWorkoutName: String = ""
    @State private var showingDeleteAlert = false
    @State private var isEditMode: EditMode = .inactive
    @State private var isEditing: Bool = true  // State to control editing
    @FocusState private var isTextFieldFocused: Bool  // Focus state
    
    @Binding var navigationPath: NavigationPath

    var body: some View {
            VStack(spacing: 5) {
                HStack {
                    InlineTextEditView(text: $editableWorkoutName, isEditing: $isEditing, isTextFieldFocused: $isTextFieldFocused)
                        .font(.title)
                        .padding(.horizontal, 30)
                    Spacer()
                    DeleteButton(message: "workout") {
                        do {
                            try workoutViewModel.delete(workout)
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("Error occurred while deleting workout: \(error.localizedDescription)")
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.top, 20)
                .onAppear(perform: {
                    editableWorkoutName = workout.type
                })
                .onChange(of: editableWorkoutName) { newValue in
                    let newInfo = WorkoutInfo(creationTime: workout.creationTime, type: newValue, template: workout.template ?? nil)
                    workoutViewModel.update(workout: workout, withNewInfo: newInfo)
                }
                
                Button(action: {
                    self.isShowingInputModal.toggle()
                    
                }) {
                    AddButton()
                }
                .background(Color.clear)
                .cornerRadius(30)
                .sheet(isPresented: $isShowingInputModal) {
                    SimpleInputModalView(inputText: $inputText, isNameNotUnique: .constant(false), onSubmit: {
                        let exercise = ExerciseModel(exercise: viewModel.addExercise(id: workout.id, name: inputText))
                        viewModel.getExercises(workout: workout)
                        navigationPath.append(exercise)
                    }, isNameValid: { true })  // Always returns true as uniqueness is not required
                }
                
                
                if viewModel.exercises.count != 0 {
                    VStack {
                        HStack {
                            Text("Exercises")
                                .font(.title2)
                                .padding(.leading, 30)
                            Spacer()
                        }
                        Divider()
                            .padding(.horizontal)
                    }
                    
                } else {
                    Text("No Exercises To Display")
                        .padding(.vertical, 20)
                }
                
                List {
                    ForEach(viewModel.exercises, id: \.id) { exercise in
                        WorkoutCard(type: exercise.name, creationTime: exercise.creationTime,
                                    colour: workoutViewModel.getColourForWorkout(workout: workout))
                            .onTapGesture {
                                navigationPath.append(exercise)
                            }
                    }
                    .onDelete(perform: deleteExercise)
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
            .navigationDestination(for: ExerciseModel.self) { exercise in
                SetListView(navigationPath: $navigationPath, exercise: exercise)
            }
            .onChange(of: viewModel.exercises.count) { newCount in
                if newCount == 0 && isEditMode == .active {
                    isEditMode = .inactive
                }
            }
            .navigationBarItems(trailing: EditButton())
            .environment(\.editMode, $isEditMode)
            .onAppear(perform: {
                viewModel.getExercises(workout: workout)
            })
    }
    func deleteExercise(at offsets: IndexSet) {
        offsets.forEach { index in
            let set = viewModel.exercises[index] // get the set to be deleted
            viewModel.delete(set)
            viewModel.getExercises(workout: workout)
            
        }
    }
}

struct ExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let mockDataManager = DataManager(storeType: .inMemory)
        let mockDataController = ExerciseData(dataManager: mockDataManager)
        

        let entity = NSEntityDescription.entity(forEntityName: "Workout", in: mockDataManager.viewContext)!
        let workout = Workout(entity: entity, insertInto: mockDataManager.viewContext)
        workout.type = "Push"
        
        let mockDataWorkoutController = WorkoutData(dataManager: mockDataManager)
        let mockViewWorkoutModel = WorkoutViewModel(controller: mockDataWorkoutController)

        let navigationPath = NavigationPath()
        
        let mockViewModel = ExerciseViewModel(controller: mockDataController)
        return ExerciseListView(workout: WorkoutModel(workout: workout), navigationPath: .constant(navigationPath))
            .environmentObject(mockViewModel)
            .environmentObject(mockViewWorkoutModel)
    }
}
