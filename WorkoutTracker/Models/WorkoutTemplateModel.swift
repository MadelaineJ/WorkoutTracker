//
//  WorkoutTemplateModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-28.
//

import Foundation
import CoreData

struct WorkoutTemplateInfo {
    let type: String
}

// used for displaying in the view
struct WorkoutTemplateModel: Hashable {
    let workout: WorkoutTemplate
    
    var id: NSManagedObjectID {
        return workout.objectID
    }
    
    var type: String {
        return workout.type ?? ""
    }
}
