//
//  ContentView.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-09-10.


import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject private var workoutViewModel: WorkoutViewModel
    @EnvironmentObject private var exerciseViewModel: ExerciseViewModel
    @EnvironmentObject private var exerciseSetViewModel: ExerciseSetViewModel
    

    var body: some View {
    
            WorkoutListView()
            .environmentObject(workoutViewModel)
            .environmentObject(exerciseViewModel)
            .environmentObject(exerciseSetViewModel)

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
        
        let mockDataExerciseSetController = ExerciseSetData(dataManager: mockDataManager)
        let mockViewExerciseSetModel = ExerciseSetViewModel(controller: mockDataExerciseSetController)
        
        return ContentView()
            .environmentObject(mockViewWorkoutModel)
            .environmentObject(mockViewExerciseModel)
            .environmentObject(mockViewExerciseSetModel)
    }
}

