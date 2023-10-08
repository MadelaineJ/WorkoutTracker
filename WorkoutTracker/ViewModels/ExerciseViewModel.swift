//
//  ExerciseViewModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import Foundation
import CoreData

class ExerciseViewModel: ObservableObject {
    
    let controller = ExerciseData.controller
    
    var name = ""
    @Published var exercises: [ExerciseModel] = []
    
    func createExercise() {
        let exercise = Exercise(context: DataManager.shared.persistentContainer.viewContext)
        exercise.creationTime = Date()
        exercise.name = name
        
        DataManager.shared.save()
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
    
    
    func delete(_ exercise: ExerciseModel) {
        let existingExercise = controller.getExerciseById(id: exercise.id)
        if let existingExercise = existingExercise {
            controller.deleteExercise(exercise: existingExercise)
        }
    }
}

struct ExerciseInfo {
    let creationTime: Date
    let name: String
}

struct ExerciseModel {
    let exercise: Exercise
    
    var id: NSManagedObjectID {
        return exercise.objectID
    }
    
    var creationTime: Date {
        return exercise.creationTime ?? Date()
    }
    
    var name: String {
        return exercise.name ?? ""
    }
}
