//
//  ContentView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-09-10.


import SwiftUI
import CoreData

struct ContentView: View {
    
    

    var body: some View {
    
            WorkoutView()
                .environmentObject(WorkoutViewModel())
                .environmentObject(ExerciseViewModel())
                .environmentObject(ExerciseSetViewModel())

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let mockDataManager = DataManager(storeType: .inMemory)
        
        // Workout Controller and ViewModel
        let mockDataWorkoutController = WorkoutData(dataManager: mockDataManager)
        let mockViewWorkoutModel = WorkoutViewModel(controller: mockDataWorkoutController)
        
        let mockDataExerciseController = ExerciseData(dataManager: mockDataManager)
        let mockViewExerciseModel = ExerciseViewModel(controller: mockDataExerciseController)
        
        return ContentView()
            .environmentObject(mockViewWorkoutModel)
            .environmentObject(mockViewExerciseModel)
    }
}

