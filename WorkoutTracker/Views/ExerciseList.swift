//
//  WorkoutDetails.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-14.
//

import SwiftUI
import CoreData

struct ExerciseList: View {
    
    var workout: WorkoutModel
    @EnvironmentObject private var viewModel: ExerciseViewModel
    
    var body: some View {
            VStack {
                Button(action: {
                    viewModel.addExercise(workout: workout)
                    viewModel.getExercises(workout: workout)
                }) {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color(.systemIndigo))
                            .padding()
                        
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                }
                .background(Color.clear)
                .cornerRadius(30)
                   
                List {
                    ForEach(viewModel.exercises, id: \.id) { exercise in
                        ZStack {
                            WorkoutCard(type: exercise.name, creationTime: exercise.creationTime)
                        }
                        
                    }
                    .onDelete(perform: deleteExercise)
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
                
            }
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

struct ExerciseList_Previews: PreviewProvider {
    static var previews: some View {
        
        let mockDataManager = DataManager(storeType: .inMemory)
        let mockDataController = ExerciseData(dataManager: mockDataManager)
        

        let entity = NSEntityDescription.entity(forEntityName: "Workout", in: mockDataManager.viewContext)!
        let workout = Workout(entity: entity, insertInto: mockDataManager.viewContext)

        
        let mockViewModel = ExerciseViewModel(controller: mockDataController)
        return ExerciseList(workout: WorkoutModel(workout: workout))
            .environmentObject(mockViewModel)
    }
}
