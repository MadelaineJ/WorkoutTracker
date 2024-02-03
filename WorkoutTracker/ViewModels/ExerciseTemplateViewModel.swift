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

    init(controller: ExerciseTemplateData = ExerciseTemplateData()) {
        self.controller = controller
    }
    
    @Published var exerciseTemplates: [ExerciseTemplateModel] = [] // Assuming you have a ExerciseTemplateModel
    
    func createExerciseTemplate(name: String) -> ExerciseTemplate {
        let exerciseTemplate = controller.createExerciseTemplate(name)
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
}
