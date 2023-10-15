//
//  ExerciseSetData.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-08.
//

import Foundation
import CoreData

class ExerciseSetData {
    
    static let controller = ExerciseSetData(dataManager: DataManager.shared) // default controller
    var dataManager: DataManager

    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }

    func createExerciseSet(_ exerciseSetInfo: ExerciseSetInfo) {
        let exerciseSet = ExerciseSet(context: dataManager.viewContext)
        exerciseSet.creationTime = exerciseSetInfo.creationTime
        exerciseSet.weight = exerciseSetInfo.weight
        exerciseSet.reps = exerciseSetInfo.reps

        dataManager.save()
    }
    
    func updateExerciseSet(existingExerciseSet: ExerciseSet, with newInfo: ExerciseSetInfo) {
        existingExerciseSet.creationTime = newInfo.creationTime
        existingExerciseSet.weight = newInfo.weight
        existingExerciseSet.reps = newInfo.reps
        dataManager.save()
    }
    
    func getAllSets() -> [ExerciseSet] {
        let request: NSFetchRequest<ExerciseSet> = ExerciseSet.fetchRequest()
        
        do {
            return try dataManager.viewContext.fetch(request)
        } catch {
            return []
        }
        
    }
    
    func getSetById(id: NSManagedObjectID) -> ExerciseSet? {
        
        do {
            let exerciseSet = try dataManager.viewContext.existingObject(with: id) as? ExerciseSet
            return exerciseSet
        } catch {
            return nil
        }
       
    }
    
    func deleteSet(exerciseSet: ExerciseSet) {
        dataManager.viewContext.delete(exerciseSet)
        do {
            try dataManager.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}
