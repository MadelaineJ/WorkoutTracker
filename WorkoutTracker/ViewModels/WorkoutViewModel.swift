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
    var templateController: WorkoutTemplateViewModel = WorkoutTemplateViewModel()

    init(controller: WorkoutData = WorkoutData()) {
        self.controller = controller
    }

    var type = ""
    @Published var workouts: [WorkoutModel] = []

    func createWorkout(type: String) -> Workout {
        let workout = WorkoutInfo(creationTime: Date(), type: type)
        return controller.createWorkout(workout)
    
    }
    
    func createWorkoutFromTemplate(workoutTemplate: WorkoutTemplateModel) {
        // Create a workout using information from the workout template
        let workoutType = workoutTemplate.type
        let workout = createWorkout(type: workoutType) // Assuming this returns a Workout object

        // Fetch the template from the database
        let template = templateController.getWorkoutTemplate(id: workoutTemplate.id)
                
        if let unwrappedExercises = template.exercises {
            for exerciseTemplate in unwrappedExercises.allObjects as! [ExerciseTemplate] {
                exerciseViewModel.addExercise(id: workout.objectID, name: exerciseTemplate.name!)
            }
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
