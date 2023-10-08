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
    
    func save() {
        let exercise = Exercise(context: DataManager.shared.persistentContainer.viewContext)
        exercise.creationTime = Date()
        exercise.name = name
        
        DataManager.shared.save()
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

struct ExerciseModel {
    let exercise: Exercise
    
    var id: NSManagedObjectID {
        return exercise.objectID
    }
    
    var name: String {
        return exercise.name ?? ""
    }
}
