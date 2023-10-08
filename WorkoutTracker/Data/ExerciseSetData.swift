//
//  ExerciseSetData.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-08.
//

import Foundation
import CoreData

class ExerciseSetData {
    
    static let controller = ExerciseSetData()
    
    
    let viewContext =  DataManager.shared.viewContext
    
    
    private init() {
        
    }
    
    func getAllSets() -> [ExerciseSet] {
        let request: NSFetchRequest<ExerciseSet> = ExerciseSet.fetchRequest()
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
        
    }
    
    func getSetById(id: NSManagedObjectID) -> ExerciseSet? {
        
        do {
            return try viewContext.existingObject(with: id) as? ExerciseSet
        } catch {
            return nil
        }
       
    }
    
    func deleteSet(set: ExerciseSet) {
        viewContext.delete(set)
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}
    // view

    // get all sets (should really return based on exercise but good enough for now




    // create


    // update


    // delete
