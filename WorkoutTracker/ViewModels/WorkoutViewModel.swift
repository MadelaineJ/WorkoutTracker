//
//  WorkoutViewModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import Foundation
import CoreData
import UIKit

class WorkoutViewModel: ObservableObject {

    var controller: WorkoutData
    var exerciseViewModel: ExerciseViewModel = ExerciseViewModel()
    var templateController: WorkoutTemplateViewModel = WorkoutTemplateViewModel()

    init(controller: WorkoutData = WorkoutData()) {
        self.controller = controller
        fetchAllUniqueWorkoutTypes()
    }

    var type = ""
    private var isSortedAscending = false
    
    @Published var workouts: [WorkoutModel] = []
    @Published var uniqueWorkoutTypes: [String] = []

    func createWorkout(type: String, colorData: Data? = nil) -> Workout {
        let workoutInfo = WorkoutInfo(creationTime: Date(), type: type)
        let workout = controller.createWorkout(workoutInfo, colorData: colorData)
        fetchAllUniqueWorkoutTypes()
        return workout
    }
    
    func fetchAllUniqueWorkoutTypes() {
        uniqueWorkoutTypes = controller.getAllUniqueWorkoutTypes()
    }
    
    func getAllWorkoutsByType(type: String) {
        workouts = controller.getAllWorkoutsByType(type: type).map(WorkoutModel.init)
    }
    
    func createWorkoutFromTemplate(workoutTemplate: WorkoutTemplateModel) -> Workout {
        // Create a workout using information from the workout template
        let workoutType = workoutTemplate.type
        let colour = workoutTemplate.colour
        let workout = createWorkout(type: workoutType, colorData: colour)

        // Fetch the template from the database
        let template = templateController.getWorkoutTemplate(id: workoutTemplate.id)
                
        if let unwrappedExercises = template.exercises {
            for exerciseTemplate in unwrappedExercises.allObjects as! [ExerciseTemplate] {
                _ = exerciseViewModel.addExercise(id: workout.objectID, name: exerciseTemplate.name!)
            }
        }
        
        return workout
    }

    func toggleWorkoutOrder(ascending: Bool) {
        isSortedAscending.toggle()
        workouts.sort(by: { ascending ? $0.creationTime < $1.creationTime : $0.creationTime > $1.creationTime })
    }

    
    func update(workout: WorkoutModel, withNewInfo newInfo: WorkoutInfo, color: UIColor? = nil) {
        if let existingWorkout = controller.getWorkoutById(id: workout.id) {
            controller.updateWorkout(existingWorkout: existingWorkout, with: newInfo, color: color)
        }
    }
    
    func getAllWorkouts() {
        workouts = controller.getAllWorkouts().sorted(by: { isSortedAscending ? $0.creationTime ?? Date() < $1.creationTime ?? Date() : $0.creationTime! > $1.creationTime! }).map(WorkoutModel.init)
    }


    func delete(_ workout: WorkoutModel) throws {
        let existingWorkout = controller.getWorkoutById(id: workout.id)
        if let existingWorkout = existingWorkout {
            try controller.deleteWorkout(workout: existingWorkout)
        }
    }

    func getColourForWorkout(workout: WorkoutModel) -> UIColor? {
        if let existingWorkout = controller.getWorkoutById(id: workout.id) {
            return controller.getColourForWorkout(workout: existingWorkout)
        }
        return nil
    }
}
