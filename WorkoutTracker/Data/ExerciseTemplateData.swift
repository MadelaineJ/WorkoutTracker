//
//  ExerciseTemplateData.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-28.
//

import CoreData

class ExerciseTemplateData {

    let workoutController: WorkoutTemplateData
    var dataManager: DataManager

    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        self.workoutController = WorkoutTemplateData(dataManager: dataManager)
    }
    
    
    func createExerciseTemplate(_ name: String) -> ExerciseTemplate {
        let exerciseTemplate = ExerciseTemplate(context: dataManager.viewContext)
        exerciseTemplate.name = name

        dataManager.save()
        
        return exerciseTemplate
    }
    
    func updateExerciseTemplate(existingExerciseTemplate: ExerciseTemplate, with newInfo: String) {
        existingExerciseTemplate.name = newInfo

        dataManager.save()
    }
    
    func getAllExerciseTemplates() -> [ExerciseTemplate] {
        let request: NSFetchRequest<ExerciseTemplate> = ExerciseTemplate.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "ExerciseTemplate.name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try dataManager.viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func getExerciseTemplates(workoutId: NSManagedObjectID) -> [ExerciseTemplate] {
        if let workout = workoutController.getWorkoutTemplateById(id: workoutId) {
            if let exerciseTemplates = workout.exercises as? Set<ExerciseTemplate> {
                let exerciseTemplatesArray = Array(exerciseTemplates)
                return exerciseTemplatesArray.sorted(by: { $0.name! < $1.name! })  // Sorting in descending order
            }
        }
        return []
    }

    
    func getExerciseTemplateById(id: NSManagedObjectID) -> ExerciseTemplate? {
        
        do {
            return try dataManager.viewContext.existingObject(with: id) as? ExerciseTemplate
        } catch {
            return nil
        }
    }
    
    func addExerciseTemplate(workoutId: NSManagedObjectID, exerciseTemplate: ExerciseTemplate) {

        guard let workout = workoutController.getWorkoutTemplateById(id: workoutId) else {
            return
        }
        
        workout.addToExercises(exerciseTemplate)
        
        do {
            try dataManager.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteExerciseTemplate(exerciseTemplate: ExerciseTemplate) {
        dataManager.viewContext.delete(exerciseTemplate)
        do {
            try dataManager.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
