//
//  WorkoutData.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-08.
//

import CoreData

class WorkoutData {
    static let controller = WorkoutData()
    
    let viewContext =  DataManager.shared.viewContext
    
    
    private init() {
        
    }
    
    func getAllWorkouts() -> [Workout] {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
        
    }
    
    func getWorkoutById(id: NSManagedObjectID) -> Workout? {
        
        do {
            return try viewContext.existingObject(with: id) as? Workout
        } catch {
            return nil
        }
       
    }
    
    func deleteWorkout(workout: Workout) {
        viewContext.delete(workout)
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

