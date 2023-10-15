//
//  ExerciseModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-14.
//

import Foundation
import CoreData

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
