//
//  WorkoutData.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-08.
//

import CoreData
import UIKit

class WorkoutData {

    var dataManager: DataManager

    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    func createWorkout(_ workoutInfo: WorkoutInfo) -> Workout {
        let workout = Workout(context: dataManager.viewContext)
        workout.creationTime = workoutInfo.creationTime
        workout.type = workoutInfo.type
        workout.template = workoutInfo.template

        dataManager.save()
        
        return workout
    }
    
    func updateWorkout(existingWorkout: Workout, with newInfo: WorkoutInfo, color: UIColor? = nil) {
        existingWorkout.creationTime = newInfo.creationTime
        existingWorkout.type = newInfo.type
        if let color = color {
            existingWorkout.colour = convertColorToData(color: color)
        }
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

    func getAllUniqueWorkoutTypes() -> [String] {
        let request: NSFetchRequest<NSFetchRequestResult> = Workout.fetchRequest()
        request.propertiesToFetch = ["type"]
        request.returnsDistinctResults = true
        request.resultType = .dictionaryResultType
        
        do {
            let results = try dataManager.viewContext.fetch(request) as? [[String: String]]
            let types = results?.compactMap { $0["type"] } ?? []
            return types
        } catch {
            print("Failed to fetch unique workout types: \(error.localizedDescription)")
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
    
    // COLOR
    private func convertColorToData(color: UIColor) -> Data {
        return try! NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
    }

    private func convertDataToColor(data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }

    func createWorkout(_ workoutInfo: WorkoutInfo, colorData: Data? = nil) -> Workout {
        let workout = Workout(context: dataManager.viewContext)
        workout.creationTime = workoutInfo.creationTime
        workout.type = workoutInfo.type
        workout.template = workoutInfo.template
        if let color = colorData {
            workout.colour = color
        }
        dataManager.save()
        return workout
    }

    func getColourForWorkout(workout: Workout) -> UIColor? {
        if let template = workout.template {
            workout.colour = template.colour

        }

        if let colorData = workout.colour {
            return convertDataToColor(data: colorData)
        }
        return nil
    }

}

