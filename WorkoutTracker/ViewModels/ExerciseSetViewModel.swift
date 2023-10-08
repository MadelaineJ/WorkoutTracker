//
//  SetViewModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import Foundation
import CoreData

class ExerciseSetViewModel: ObservableObject {
    
    let controller = ExerciseSetData.controller
    
    var weight = ""
    var reps = ""
    @Published var exerciseSets: [SetModel] = []
    
    func createExerciseSet() {
        let exerciseSet = ExerciseSet(context: DataManager.shared.persistentContainer.viewContext)
        exerciseSet.creationTime = Date()
        exerciseSet.weight = Int64(weight) ?? 0
        exerciseSet.reps = Int64(reps) ?? 0
        
        DataManager.shared.save()
    }
    
    func update(exerciseSet: SetModel, withNewInfo newInfo: ExerciseSetInfo) {
        let existingExerciseSet = controller.getSetById(id: exerciseSet.id)
        if let existingExerciseSet = existingExerciseSet {
            controller.updateExerciseSet(existingExerciseSet: existingExerciseSet, with: newInfo)
        }
    }
    func getAllSets() {
        exerciseSets = controller.getAllSets().map(SetModel.init)
    }
    
    
    func delete(_ exerciseSet: SetModel) {
        let existingSet = controller.getSetById(id: exerciseSet.id)
        if let existingSet = existingSet {
            controller.deleteSet(exerciseSet: existingSet)
        }
    }
}

struct ExerciseSetInfo {
    let creationTime: Date
    let weight: Int64
    let reps: Int64
}

struct SetModel {
    let exerciseSet: ExerciseSet
    
    var id: NSManagedObjectID {
        return exerciseSet.objectID
    }
    
    var weight: Int64 {
        return exerciseSet.weight
    }
    
    var reps: Int64 {
        return exerciseSet.reps
    }
}


