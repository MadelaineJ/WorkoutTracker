//
//  SetListView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import SwiftUI
import CoreData

struct SetListView: View {
    var exercise: ExerciseModel
    @EnvironmentObject private var viewModel: ExerciseSetViewModel
    @EnvironmentObject private var exerciseViewModel: ExerciseViewModel
    
    @State private var editableExerciseName: String = ""
    @State private var listScrollPosition: UUID?
    @State private var exerciseSetCount: Int = 0
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            GeometryReader { geometry in
                VStack {
                    
                    HStack {
                        HStack(spacing: 0) {
                            Text("Sets for ")
                                .font(.title)
                            InlineTextEditView(text: $editableExerciseName)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(0)
                        }
                        Spacer()
                    }
                    .onAppear(perform: {
                        editableExerciseName = exercise.name
                    })
                    .onChange(of: editableExerciseName) { newValue in
                        let newInfo = ExerciseInfo(creationTime: exercise.creationTime, name: newValue)
                        exerciseViewModel.update(exercise: exercise, withNewInfo: newInfo)
                    }
                    .padding(.horizontal, 30)
                    
                    Button(action: {
                        viewModel.addExerciseSet(exercise: exercise)
                        viewModel.getExerciseSets(exercise: exercise)
                    }) {
                        AddButton()
                    }
                    .background(Color.clear)
                    .cornerRadius(30)
                    if viewModel.exerciseSets.count == 0 {
                        Text("No Sets To Display")
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
                        Color.clear.frame(height: 1 ) // Invisible view with some height, acting as scroll target
                            .id("bottomPadding")
                    }
                    .listStyle(PlainListStyle())

                }
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
        exercise.name = "Push"
        
        let mockViewModel = ExerciseSetViewModel(controller: mockDataController)
        
        let mockExerciseDataManager = DataManager(storeType: .inMemory)
        let mockExerciseDataController = ExerciseData(dataManager: mockExerciseDataManager)
        let mockExericseViewModel = ExerciseViewModel(controller: mockExerciseDataController)
        
        
        return SetListView(exercise: ExerciseModel(exercise: exercise))
            .environmentObject(mockViewModel)
            .environmentObject(mockExericseViewModel)
    }
    
}
