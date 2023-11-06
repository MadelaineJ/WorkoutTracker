//
//  ExerciseSetData.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-08.
//

import Foundation
import CoreData

class ExerciseSetData {
    
    let exerciseController: ExerciseData
    var dataManager: DataManager

    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        self.exerciseController = ExerciseData(dataManager: dataManager)
    }

    func createExerciseSet(_ exerciseSetInfo: ExerciseSetInfo) -> ExerciseSet {
        let exerciseSet = ExerciseSet(context: dataManager.viewContext)
        exerciseSet.creationTime = exerciseSetInfo.creationTime
        exerciseSet.weight = exerciseSetInfo.weight
        exerciseSet.reps = exerciseSetInfo.reps

        dataManager.save()
        
        return exerciseSet
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
    
    func getExerciseSets(exerciseId: NSManagedObjectID) -> [ExerciseSet] {
        if let exercise = exerciseController.getExerciseById(id: exerciseId) {
            if let exercisesSets = exercise.sets as? Set<ExerciseSet> {
                let exercisesSetsArray = Array(exercisesSets)
                return exercisesSetsArray.sorted(by: { $0.creationTime! < $1.creationTime! })  // Sorting in descending order
            }
        }
        return []
    }

    
    func getSetById(id: NSManagedObjectID) -> ExerciseSet? {
        
        do {
            let exerciseSet = try dataManager.viewContext.existingObject(with: id) as? ExerciseSet
            return exerciseSet
        } catch {
            return nil
        }
       
    }
    
    func addExerciseSet(exerciseId: NSManagedObjectID, exerciseSet: ExerciseSet) {

        guard let exercise = exerciseController.getExerciseById(id: exerciseId) else {
            return
        }
        
        exercise.addToSets(exerciseSet)
        
        do {
            try dataManager.viewContext.save()
        } catch {
            print(error.localizedDescription)
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
