//
//  WorkoutViewModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import Foundation
import CoreData

class WorkoutViewModel: ObservableObject {
    
    let controller = WorkoutData.controller
    
    var type = ""
    @Published var workouts: [WorkoutModel] = []
    
    func save() {
        let workout = Workout(context: DataManager.shared.persistentContainer.viewContext)
        workout.creationTime = Date()
        workout.type = type
        
        DataManager.shared.save()
    }
    
    func getAllWorkouts() {
        workouts = controller.getAllWorkouts().map(WorkoutModel.init)
    }
    
    
    func delete(_ workout: WorkoutModel) {
        let existingWorkout = controller.getWorkoutById(id: workout.id)
        if let existingWorkout = existingWorkout {
            controller.deleteWorkout(workout: existingWorkout)
        }
    }
}

struct WorkoutModel {
    let workout: Workout
    
    var id: NSManagedObjectID {
        return workout.objectID
    }
    
    var type: String {
        return workout.type ?? ""
    }
}
