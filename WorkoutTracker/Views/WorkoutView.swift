//
//  WorkoutView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject private var viewModel: WorkoutViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    viewModel.createWorkout()
                    viewModel.getAllWorkouts()
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
                if viewModel.workouts.count == 0 {
                    Text("No Workouts To Display")
                }
                    List {
                        ForEach(viewModel.workouts, id: \.id) { workout in
                            ZStack {
                                NavigationLink(destination: ExerciseList(workout: workout)) {
                                    EmptyView()                                }
                                .opacity(0) // Make it invisible
                                
                                WorkoutCard(type: workout.type, creationTime: workout.creationTime)
                            }
                            
                        }
                        .onDelete(perform: deleteWorkout)
                        .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                
            }
            .onAppear(perform: {
                viewModel.getAllWorkouts()
            })
        }
        .background(Color(.systemGray2))

    }
    
    func deleteWorkout(at offsets: IndexSet) {
        offsets.forEach { index in
            let workout = viewModel.workouts[index] // get the set to be deleted
            viewModel.delete(workout)
            viewModel.getAllWorkouts()
        }
    }
}


struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        let mockDataManager = DataManager(storeType: .inMemory)
        
        let mockDataWorkoutController = WorkoutData(dataManager: mockDataManager)
        let mockViewWorkoutModel = WorkoutViewModel(controller: mockDataWorkoutController)
        
        let mockDataExerciseController = ExerciseData(dataManager: mockDataManager)
        let mockViewExerciseModel = ExerciseViewModel(controller: mockDataExerciseController)
        
        return WorkoutView()
            .environmentObject(mockViewWorkoutModel)
            .environmentObject(mockViewExerciseModel)
    }
}
