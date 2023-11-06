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
        fetchAllUniqueWorkoutTypes()
    }

    var type = ""
    private var isSortedAscending = false
    
    @Published var workouts: [WorkoutModel] = []
    @Published var uniqueWorkoutTypes: [String] = []

    func createWorkout(type: String) -> Workout {
        let workoutInfo = WorkoutInfo(creationTime: Date(), type: type)
        let workout = controller.createWorkout(workoutInfo)
        fetchAllUniqueWorkoutTypes()
        return workout
        
    }
    
    func fetchAllUniqueWorkoutTypes() {
        uniqueWorkoutTypes = controller.getAllUniqueWorkoutTypes()
    }
    
    func getAllWorkoutsByType(type: String) {
        workouts = controller.getAllWorkoutsByType(type: type).map(WorkoutModel.init)
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

    func toggleWorkoutOrder(ascending: Bool) {
        isSortedAscending.toggle()
        workouts.sort(by: { ascending ? $0.creationTime < $1.creationTime : $0.creationTime > $1.creationTime })
    }

    
    func update(workout: WorkoutModel, withNewInfo newInfo: WorkoutInfo) {
        let existingWorkout = controller.getWorkoutById(id: workout.id)
        if let existingWorkout = existingWorkout {
            controller.updateWorkout(existingWorkout: existingWorkout, with: newInfo)
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
}
