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
    var exerciseViewModel: ExerciseViewModel = ExerciseViewModel()

    init(controller: WorkoutData = WorkoutData()) {
        self.controller = controller
    }

    var type = ""
    @Published var workouts: [WorkoutModel] = []

    func createWorkout(type: String) {
        let workout = WorkoutInfo(creationTime: Date(), type: type)
        controller.createWorkout(workout)
    }
    
    func createWorkoutFromTemplate(workoutTemplate: WorkoutTemplateModel) {
        // Create a workout using information from the workout template
        let workoutType = workoutTemplate.type
        createWorkout(type: workoutType)
        
        // Assuming that workoutTemplate has a 'exercises' property that is an array of ExerciseTemplateModel
        for exerciseTemplate in workoutTemplate.exercises {
            _ = exerciseViewModel.createExerciseFromTemplate(exerciseTemplate: exerciseTemplate)
        }
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

    func delete(_ workout: WorkoutModel) throws {
        let existingWorkout = controller.getWorkoutById(id: workout.id)
        if let existingWorkout = existingWorkout {
            try controller.deleteWorkout(workout: existingWorkout)
        }
    }
}
