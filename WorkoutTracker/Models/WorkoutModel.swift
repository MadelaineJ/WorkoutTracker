//
//  WorkoutModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-14.
//

import Foundation
import CoreData

struct WorkoutInfo {
    let creationTime: Date
    let type: String
}


// used for displaying in the view
struct WorkoutModel {
    let workout: Workout
    
    var id: NSManagedObjectID {
        return workout.objectID
    }
    
    var creationTime: Date {
        return workout.creationTime ?? Date()
    }
    
    var type: String {
        return workout.type ?? ""
    }
}
