//
//  ExerciseData.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-08.
//

import Foundation
import CoreData

class ExerciseData {
    static let controller = ExerciseData()
    
    let viewContext =  DataManager.shared.viewContext
    
    
    private init() {
        
    }
    
    func getAllExercises() -> [Exercise] {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
        
    }
    
    func getExerciseById(id: NSManagedObjectID) -> Exercise? {
        
        do {
            return try viewContext.existingObject(with: id) as? Exercise
        } catch {
            return nil
        }
       
    }
    
    func deleteExercise(exercise: Exercise) {
        viewContext.delete(exercise)
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
