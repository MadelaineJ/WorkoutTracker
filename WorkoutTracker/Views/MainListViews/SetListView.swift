//
//  SetListView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import SwiftUI
import CoreData

struct SetListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var viewModel: ExerciseSetViewModel
    @EnvironmentObject private var exerciseViewModel: ExerciseViewModel
    
    @State private var editableExerciseName: String = ""
    @State private var listScrollPosition: UUID?
    @State private var exerciseSetCount: Int = 0
    @State private var isEditMode: EditMode = .inactive
    
    var exercise: ExerciseModel
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            GeometryReader { geometry in
                VStack(spacing: 5) {
                    HStack {
                        InlineTextEditView(text: $editableExerciseName)
                            .font(.title)
                            .padding(.horizontal, 20)
                        Spacer()
                        DeleteButton(message: "exercise") {
                            exerciseViewModel.delete(exercise)
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.horizontal, 30)
                    }
                    .onAppear(perform: {
                        editableExerciseName = exercise.name
                    })
                    .onChange(of: editableExerciseName) { newValue in
                        let newInfo = ExerciseInfo(creationTime: exercise.creationTime, name: newValue)
                        exerciseViewModel.update(exercise: exercise, withNewInfo: newInfo)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        viewModel.addExerciseSet(exercise: exercise)
                        viewModel.getExerciseSets(exercise: exercise)
                    }) {
                        AddButton()
                    }
                    .background(Color.clear)
                    .cornerRadius(30)

                    if viewModel.exerciseSets.count != 0 {
                        VStack {
                            HStack {
                                Text("Sets")
                                    .font(.title2)
                                    .padding(.leading, 30)
                                Spacer()
                            }
                            Divider()
                                .padding(.horizontal)
                        }

                    } else {
                        Text("No Sets To Display")
                            .padding(.vertical, 20)
                    }
                    
                    List {
                        ForEach(Array(viewModel.exerciseSets.enumerated()), id: \.element.id) { index, exerciseSet in
                            SetCard(
                                enteredWeight: Binding<String>(
                                    get: { String(exerciseSet.weight) },
                                    set: { newValue in
                                        if let intValue = Int64(newValue) {
                                            let newInfo = ExerciseSetInfo(creationTime: exerciseSet.creationTime, weight: intValue, reps: exerciseSet.reps)
                                            viewModel.update(exerciseSet: exerciseSet, withNewInfo: newInfo)
                                            viewModel.getExerciseSets(exercise: exercise)
                                        }
                                    }),
                                selectedReps: Binding<Int>(
                                    get: { Int(exerciseSet.reps) },
                                    set: { newValue in
                                        let newInfo = ExerciseSetInfo(creationTime: exerciseSet.creationTime, weight: exerciseSet.weight, reps: Int64(newValue))
                                        viewModel.update(exerciseSet: exerciseSet, withNewInfo: newInfo)
                                        viewModel.getExerciseSets(exercise: exercise)
                                    })
                            )
                            .id(exerciseSet.id)
                        }
                        .onDelete(perform: deleteExercise)
                        .listRowSeparator(.hidden)
                        Color.clear.frame(width: 1) // Zero size frame
                            .id("bottomPadding")
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())

                }
                .onChange(of: viewModel.exerciseSets.count) { newCount in
                    if newCount == 0 && isEditMode == .active {
                        isEditMode = .inactive
                    }
                }
                .navigationBarItems(trailing: EditButton())
                .environment(\.editMode, $isEditMode)
                .onAppear(perform: {
                    viewModel.getExerciseSets(exercise: exercise)
                    exerciseSetCount = viewModel.exerciseSets.count
                })
                .onChange(of: viewModel.exerciseSets.count) { newCount in
                    if newCount > exerciseSetCount {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // slight delay
                            withAnimation {
                                scrollProxy.scrollTo("bottomPadding", anchor: .bottom) // Scroll to the invisible view
                            }
                        }
                    }
                    exerciseSetCount = newCount
                }
            }
        }
    }
    func deleteExercise(at offsets: IndexSet) {
        offsets.forEach { index in
            let set = viewModel.exerciseSets[index] // get the set to be deleted
            viewModel.delete(set)
            viewModel.getExerciseSets(exercise: exercise)
        }
    }
}

struct SetListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let mockDataManager = DataManager(storeType: .inMemory)
        let mockDataController = ExerciseSetData(dataManager: mockDataManager)
        
        let entity = NSEntityDescription.entity(forEntityName: "Exercise", in: mockDataManager.viewContext)!
        let exercise = Exercise(entity: entity, insertInto: mockDataManager.viewContext)
        exercise.name = "Bench Press"
        
        let mockViewModel = ExerciseSetViewModel(controller: mockDataController)
        
        let mockExerciseDataManager = DataManager(storeType: .inMemory)
        let mockExerciseDataController = ExerciseData(dataManager: mockExerciseDataManager)
        let mockExericseViewModel = ExerciseViewModel(controller: mockExerciseDataController)
        
        return SetListView(exercise: ExerciseModel(exercise: exercise))
            .environmentObject(mockViewModel)
            .environmentObject(mockExericseViewModel)
    }
    
}
