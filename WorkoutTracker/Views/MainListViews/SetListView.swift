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
    
    
    var body: some View {
            VStack {
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
                    }
                    .onDelete(perform: deleteExercise)
                    .listRowSeparator(.hidden)

                }
                
                .listStyle(PlainListStyle())
            }
            .onAppear(perform: {
                viewModel.getExerciseSets(exercise: exercise)
            })
            .navigationBarTitle("Sets for \(exercise.name)", displayMode: .large)
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
        exercise.name = "push"
        
        let mockViewModel = ExerciseSetViewModel(controller: mockDataController)
        return SetListView(exercise: ExerciseModel(exercise: exercise))
            .environmentObject(mockViewModel)
    }
    
}
