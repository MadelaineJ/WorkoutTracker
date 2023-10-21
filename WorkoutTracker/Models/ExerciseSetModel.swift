//
//  ExerciseSetModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-14.
//

import Foundation
import CoreData

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
    
    var creationTime: Date {
        return exerciseSet.creationTime ?? Date()
    }
    
    var weight: Int64 {
        return exerciseSet.weight
    }
    
    var reps: Int64 {
        return exerciseSet.reps
    }
}
