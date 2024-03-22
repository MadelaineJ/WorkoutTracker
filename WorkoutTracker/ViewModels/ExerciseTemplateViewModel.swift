//
//  ExerciseTemplateViewModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-28.
//

import Foundation
import CoreData

class ExerciseTemplateViewModel: ObservableObject {
    
    var controller: ExerciseTemplateData
    var workoutViewModel: WorkoutTemplateViewModel = WorkoutTemplateViewModel()

    init(controller: ExerciseTemplateData = ExerciseTemplateData()) {
        self.controller = controller
    }
    
    @Published var exerciseTemplates: [ExerciseTemplateModel] = [] // Assuming you have a ExerciseTemplateModel
    
    func createExerciseTemplate(name: String) -> ExerciseTemplate {
        let exerciseTemplate = controller.createExerciseTemplate(name)
        getAllExerciseTemplates()
        return exerciseTemplate
    }
    
    func update(exerciseTemplate: ExerciseTemplateModel, withNewInfo newInfo: String) {
        let existingExerciseTemplate = controller.getExerciseTemplateById(id: exerciseTemplate.id)
        if let existingExerciseTemplate = existingExerciseTemplate {
            controller.updateExerciseTemplate(existingExerciseTemplate: existingExerciseTemplate, with: newInfo)
        }
    }
    
    func getAllExerciseTemplates() {
        exerciseTemplates = controller.getAllExerciseTemplates().map(ExerciseTemplateModel.init) // Assuming you have a similar initializer in ExerciseTemplateModel
    }
    
    func returnAllExerciseTemplates() -> [ExerciseTemplateModel] {
        return controller.getAllExerciseTemplates().map(ExerciseTemplateModel.init) // Assuming you have a similar initializer in ExerciseTemplateModel
    }
    
    func getExerciseTemplates(workoutTemplate: WorkoutTemplateModel) {
        exerciseTemplates = controller.getExerciseTemplates(workoutId: workoutTemplate.id).map(ExerciseTemplateModel.init)
    }
    
    
    // TODO: refactor this function to be simpler
    func addExerciseTemplate(workoutTemplate: WorkoutTemplateModel, name: String) {
        // First, try to find an existing exercise template with the same name for this workout
        let existingTemplates = returnAllExerciseTemplates() // Assuming this returns [ExerciseTemplateModel]
        var existingTemplate = existingTemplates.first(where: { $0.name == name })

        if existingTemplate == nil {
            // If no existing template is found, create a new one and convert it to ExerciseTemplateModel if necessary
            let newExerciseTemplate = createExerciseTemplate(name: name) // Assuming this returns ExerciseTemplate
            // Convert newExerciseTemplate to ExerciseTemplateModel
            existingTemplate = ExerciseTemplateModel(exercise: newExerciseTemplate)
        }

        // Ensure existingTemplate is not nil and is the correct type before calling the add method
        if let safeTemplate = existingTemplate {
            // Assuming workoutId expects a String and safeTemplate is now an ExerciseTemplateModel
            if let exericse = controller.getExerciseTemplateById(id: safeTemplate.id) {
                controller.addExerciseTemplate(workoutId: workoutTemplate.id, exerciseTemplate: exericse)
            }

        }
    }

    
    func delete(_ exerciseTemplate: ExerciseTemplateModel) {
        let existingExerciseTemplate = controller.getExerciseTemplateById(id: exerciseTemplate.id)
        if let existingExerciseTemplate = existingExerciseTemplate {
            controller.deleteExerciseTemplate(exerciseTemplate: existingExerciseTemplate)
        }
    }
    
    func remove(exerciseTemplate: ExerciseTemplateModel, workoutTemplate: WorkoutTemplateModel) {
        _ = workoutViewModel.getWorkoutTemplate(id: workoutTemplate.id)
        if let exercise = controller.getExerciseTemplateById(id: exerciseTemplate.id) {
            controller.removeExerciseTemplate(workoutId: workoutTemplate.id, exerciseTemplate: exercise)
        }

    }
    
    func checkDelete(exerciseTemplate: ExerciseTemplateModel) -> Bool {
        workoutViewModel.getAllWorkoutTemplates()
        let workouts = workoutViewModel.workoutTemplates
        for workout in workouts {
            if workoutViewModel.getExercisesForWorkout(workoutTemplate: workout).contains(exerciseTemplate) {
                print("this exercise: \(exerciseTemplate) exists for workout: \(workout)")
                return false
            }
        }
        
        return true
    }
    
    
}
