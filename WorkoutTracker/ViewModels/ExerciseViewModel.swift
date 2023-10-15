//
//  ExerciseViewModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import Foundation
import CoreData

class ExerciseViewModel: ObservableObject {
    
    var controller: ExerciseData

    init(controller: ExerciseData = ExerciseData()) {
        self.controller = controller
    }
    
    var name = "pushup"
    @Published var exercises: [ExerciseModel] = []
    
    func createExercise() -> Exercise {
        let exercise = controller.createExercise(ExerciseInfo(creationTime: Date(), name: name))
        return exercise
    }
    
    func update(exercise: ExerciseModel, withNewInfo newInfo: ExerciseInfo) {
        let existingExercise = controller.getExerciseById(id: exercise.id)
        if let existingExercise = existingExercise {
            controller.updateExercise(existingExercise: existingExercise, with: newInfo)
        }
    }
    
    func getAllExercises() {
        exercises = controller.getAllExercises().map(ExerciseModel.init)
    }
    
    func getExercises(workout: WorkoutModel) {
        exercises = controller.getExercises(workoutId: workout.id).map(ExerciseModel.init)
    }
    
    func addExercise(workout: WorkoutModel) {
        let exercise = createExercise()
        
        controller.addExercise(workoutId: workout.id, exercise: exercise)
        
    }
    
    func delete(_ exercise: ExerciseModel) {
        let existingExercise = controller.getExerciseById(id: exercise.id)
        if let existingExercise = existingExercise {
            controller.deleteExercise(exercise: existingExercise)
        }
    }
}

