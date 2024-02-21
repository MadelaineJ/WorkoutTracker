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
    
    func addExerciseTemplate(workoutTemplate: WorkoutTemplateModel, name: String) {
        let exerciseTemplate = createExerciseTemplate(name: name)
        controller.addExerciseTemplate(workoutId: workoutTemplate.id, exerciseTemplate: exerciseTemplate)
    }
    
    func delete(_ exerciseTemplate: ExerciseTemplateModel) {
        let existingExerciseTemplate = controller.getExerciseTemplateById(id: exerciseTemplate.id)
        if let existingExerciseTemplate = existingExerciseTemplate {
            controller.deleteExerciseTemplate(exerciseTemplate: existingExerciseTemplate)
        }
    }
    
    func checkDelete(exerciseTemplate: ExerciseTemplateModel) -> Bool {
        workoutViewModel.getAllWorkoutTemplates()
        let workouts = workoutViewModel.workoutTemplates
        for workout in workouts {
            if workoutViewModel.getExercisesForWorkout(workoutTemplate: workout).contains(exerciseTemplate) {
                return false
            }
        }
        
        return true
    }
}
