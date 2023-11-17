//
//  ExerciseTemplateModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-28.
//

import Foundation
import CoreData

struct ExerciseTemplateInfo {
    let name: String
}

struct ExerciseTemplateModel: Identifiable {
    let exercise: ExerciseTemplate
    
    var id: NSManagedObjectID {
        return exercise.objectID
    }
    
    var name: String {
        return exercise.name ?? ""
    }
}
