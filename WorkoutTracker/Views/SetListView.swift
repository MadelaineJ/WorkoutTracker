//
//  ExerciseView.swift
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
                    viewModel.createExerciseSet()
                    viewModel.getExerciseSets()
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
                    ForEach(viewModel.exerciseSets, id: \.id) { exerciseSet in
                        HStack {
                            Text(String(exerciseSet.reps))
                            Text(String(exerciseSet.weight))
                        }
                        
                    }
                    .onDelete(perform: deleteExercise)
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
                
            }
            .onAppear(perform: {
                viewModel.getExerciseSets()
            })

    }
    func deleteExercise(at offsets: IndexSet) {
        offsets.forEach { index in
            let set = viewModel.exerciseSets[index] // get the set to be deleted
            viewModel.delete(set)
            
        }
    }
}

struct SetListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockDataManager = DataManager(storeType: .inMemory)
        let mockDataController = ExerciseSetData(dataManager: mockDataManager)

        let entity = NSEntityDescription.entity(forEntityName: "Exercise", in: mockDataManager.viewContext)!
        let exercise = Exercise(entity: entity, insertInto: mockDataManager.viewContext)

        let mockViewModel = ExerciseSetViewModel(controller: mockDataController)
        return SetListView(exercise: ExerciseModel(exercise: exercise))
            .environmentObject(mockViewModel)
    }
}
