//
//  WorkoutData.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-08.
//

import CoreData

class WorkoutData {

    var dataManager: DataManager

    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    func createWorkout(_ workoutInfo: WorkoutInfo) -> Workout {
        let workout = Workout(context: dataManager.viewContext)
        workout.creationTime = workoutInfo.creationTime
        workout.type = workoutInfo.type

        dataManager.save()
        
        return workout
    }
    
    func updateWorkout(existingWorkout: Workout, with newInfo: WorkoutInfo) {
        existingWorkout.creationTime = newInfo.creationTime
        existingWorkout.type = newInfo.type

        dataManager.save()
    }
    
    func getAllWorkouts() -> [Workout] {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        
        // Add a sort descriptor to sort by creationTime in descending order
        let sortDescriptor = NSSortDescriptor(key: "creationTime", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try dataManager.viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func getAllWorkoutsByType(type: String) -> [Workout] {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        // Create a predicate to filter workouts by the given type
        request.predicate = NSPredicate(format: "type == %@", type)
        
        // Add a sort descriptor if you want the results sorted, e.g., by creationTime
        let sortDescriptor = NSSortDescriptor(key: "creationTime", ascending: false)
        request.sortDescriptors = [sortDescriptor]

        do {
            // Fetch and return workouts that match the type
            return try dataManager.viewContext.fetch(request)
        } catch {
            // In case of error, return an empty array
            print("Error fetching workouts by type: \(error)")
            return []
        }
    }


    
    func getWorkoutById(id: NSManagedObjectID) -> Workout? {
        
        do {
            return try dataManager.viewContext.existingObject(with: id) as? Workout
        } catch {
            return nil
        }
    }
    
    func deleteWorkout(workout: Workout) throws {
        dataManager.viewContext.delete(workout)
        try dataManager.viewContext.save()
    }

}

