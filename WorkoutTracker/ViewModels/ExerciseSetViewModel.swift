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
    @Published var sets: [SetModel] = []
    
    func save() {
        let set = ExerciseSet(context: DataManager.shared.persistentContainer.viewContext)
        set.creationTime = Date()
        set.weight = Int64(weight) ?? 0
        set.reps = Int64(reps) ?? 0
        
        DataManager.shared.save()
    }
    
    func getAllSets() {
        sets = controller.getAllSets().map(SetModel.init)
    }
    
    
    func delete(_ set: SetModel) {
        let existingSet = controller.getSetById(id: set.id)
        if let existingSet = existingSet {
            controller.deleteSet(set: existingSet)
        }
    }
}

struct SetModel {
    let set: ExerciseSet
    
    var id: NSManagedObjectID {
        return set.objectID
    }
    
    var weight: Int64 {
        return set.weight
    }
    
    var reps: Int64 {
        return set.reps
    }
}


