//
//  WorkoutTrackerApp.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-09-10.
//

import SwiftUI

@main
struct WorkoutTrackerApp: App {
    let dataManager = DataManager.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(WorkoutViewModel())
                .environmentObject(ExerciseViewModel())
                .environmentObject(ExerciseSetViewModel())
                .environmentObject(WorkoutTemplateViewModel())
                .environmentObject(ExerciseTemplateViewModel())

        }
    }
}
