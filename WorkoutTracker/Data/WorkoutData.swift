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
    
    func createWorkout(_ workoutInfo: WorkoutInfo) {
        let workout = Workout(context: dataManager.viewContext)
        workout.creationTime = workoutInfo.creationTime
        workout.type = workoutInfo.type

        dataManager.save()
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

    
    func getWorkoutById(id: NSManagedObjectID) -> Workout? {
        
        do {
            return try dataManager.viewContext.existingObject(with: id) as? Workout
        } catch {
            return nil
        }
    }
    
    func deleteWorkout(workout: Workout) {
        dataManager.viewContext.delete(workout)
        do {
            try dataManager.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

