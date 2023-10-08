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
            ContentView()
                .environment(\.managedObjectContext, dataManager.viewContext)
        }
    }
}
