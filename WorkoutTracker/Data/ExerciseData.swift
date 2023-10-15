//
//  ExerciseData.swift
//  ExerciseTracker
//
//  Created by Madelaine Jones on 2023-10-08.
//

import Foundation
import CoreData

class ExerciseData {

    let workoutController: WorkoutData
    var dataManager: DataManager

    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        self.workoutController = WorkoutData(dataManager: dataManager)
    }
    
    
    func createExercise(_ exerciseInfo: ExerciseInfo) -> Exercise {
        let exercise = Exercise(context: dataManager.viewContext)
        exercise.creationTime = exerciseInfo.creationTime
        exercise.name = exerciseInfo.name

        dataManager.save()
        
        return exercise
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
    
    func getExercises(workoutId: NSManagedObjectID) -> [Exercise] {
        if let workout = workoutController.getWorkoutById(id: workoutId) {
            if let exercises = workout.exercises as? Set<Exercise> {
                let exercisesArray = Array(exercises)
                return exercisesArray
            }
        }
        return []
    }
    
    func getExerciseById(id: NSManagedObjectID) -> Exercise? {
        
        do {
            return try dataManager.viewContext.existingObject(with: id) as? Exercise
        } catch {
            return nil
        }
    }
    
    func addExercise(workoutId: NSManagedObjectID, exercise: Exercise) {

        guard let workout = workoutController.getWorkoutById(id: workoutId) else {
            return
        }
        
        workout.addToExercises(exercise)
        
        do {
            try dataManager.viewContext.save()
        } catch {
            print(error.localizedDescription)
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
