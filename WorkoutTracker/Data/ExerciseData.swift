//
//  ExerciseData.swift
//  ExerciseTracker
//
//  Created by Madelaine Jones on 2023-10-08.
//

import Foundation
import CoreData

class ExerciseData {

    static let controller = ExerciseData()
    var dataManager = DataManager.shared
    
    init() {
        
    }
    
    func createExercise(_ exerciseInfo: ExerciseInfo) {
        let exercise = Exercise(context: dataManager.viewContext)
        exercise.creationTime = exerciseInfo.creationTime
        exercise.name = exerciseInfo.name

        dataManager.save()
    }
    
    func updateExercise(existingExercise: Exercise, with newInfo: ExerciseInfo) {
        existingExercise.creationTime = newInfo.creationTime
        existingExercise.name = newInfo.name

        dataManager.save()
    }
    
    func getAllExercises() -> [Exercise] {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        
        do {
            return try dataManager.viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func getExerciseById(id: NSManagedObjectID) -> Exercise? {
        
        do {
            return try dataManager.viewContext.existingObject(with: id) as? Exercise
        } catch {
            return nil
        }
    }
    
    func deleteExercise(exercise: Exercise) {
        dataManager.viewContext.delete(exercise)
        do {
            try dataManager.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
