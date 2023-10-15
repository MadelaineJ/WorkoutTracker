//
//  WorkoutViewModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import Foundation
import CoreData

class WorkoutViewModel: ObservableObject {

    var controller: WorkoutData

    init(controller: WorkoutData = WorkoutData()) {
        self.controller = controller
    }

    var type = ""
    @Published var workouts: [WorkoutModel] = []

    func createWorkout() {
        let workout = WorkoutInfo(creationTime: Date(), type: "push")
        controller.createWorkout(workout)
    }
    
    func update(workout: WorkoutModel, withNewInfo newInfo: WorkoutInfo) {
        let existingWorkout = controller.getWorkoutById(id: workout.id)
        if let existingWorkout = existingWorkout {
            controller.updateWorkout(existingWorkout: existingWorkout, with: newInfo)
        }
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
