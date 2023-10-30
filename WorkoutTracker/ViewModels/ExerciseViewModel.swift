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
    
    @Published var exercises: [ExerciseModel] = []
    
    func createExercise(name: String) -> Exercise {
        let exercise = controller.createExercise(ExerciseInfo(creationTime: Date(), name: name))
        return exercise
    }
    
    func createExerciseFromTemplate(exerciseTemplate: ExerciseTemplateModel) -> Exercise {
        // Create an exercise using information from the exercise template
        let exerciseName = exerciseTemplate.name
        return createExercise(name: exerciseName)
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
    
    func addExercise(id: NSManagedObjectID, name: String) {
        let exercise = createExercise(name: name)
        controller.addExercise(workoutId: id, exercise: exercise)
        
    }
    
    func delete(_ exercise: ExerciseModel) {
        let existingExercise = controller.getExerciseById(id: exercise.id)
        if let existingExercise = existingExercise {
            controller.deleteExercise(exercise: existingExercise)
        }
    }
}

