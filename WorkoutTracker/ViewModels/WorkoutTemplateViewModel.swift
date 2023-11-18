//
//  WorkoutTemplateViewModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-28.
//

import Foundation
import CoreData
import Combine  // If you are using Combine for @Published property
import UIKit

class WorkoutTemplateViewModel: ObservableObject {

    var controller: WorkoutTemplateData
    var exerciseController: ExerciseTemplateData


    init(controller: WorkoutTemplateData = WorkoutTemplateData(),
         exerciseController: ExerciseTemplateData = ExerciseTemplateData()) {
        self.controller = controller
        self.exerciseController = exerciseController
    }

    var type = ""
    @Published var workoutTemplates: [WorkoutTemplateModel] = []

    func createWorkoutTemplate(type: String) -> WorkoutTemplate? {
        let newWorkoutTemplate = controller.createWorkoutTemplate(type)
        getAllWorkoutTemplates()  // Update the list after creating
        return newWorkoutTemplate
    }

    func update(workoutTemplate: WorkoutTemplateModel, withNewInfo newInfo: WorkoutTemplateInfo) {
        if let existingWorkoutTemplate = controller.getWorkoutTemplateById(id: workoutTemplate.id) {
            controller.updateWorkoutTemplate(existingWorkoutTemplate: existingWorkoutTemplate, with: newInfo)
            getAllWorkoutTemplates()  // Update the list after updating
        }
    }
    
    func getWorkoutTemplate(id: NSManagedObjectID) -> WorkoutTemplate {
        return controller.getWorkoutTemplateById(id: id) ?? WorkoutTemplate()
    }

    func getAllWorkoutTemplates() {
        workoutTemplates = controller.getAllWorkoutTemplates().map(WorkoutTemplateModel.init)
    }
    
    func getExercisesForWorkout(workoutTemplate: WorkoutTemplateModel) -> [ExerciseTemplateModel] {
        return exerciseController.getExerciseTemplates(workoutId: workoutTemplate.id).map(ExerciseTemplateModel.init)
    }

    func delete(_ workoutTemplate: WorkoutTemplateModel) {
        if let existingWorkoutTemplate = controller.getWorkoutTemplateById(id: workoutTemplate.id) {
            do {
                try controller.deleteWorkoutTemplate(workoutTemplate: existingWorkoutTemplate)
                getAllWorkoutTemplates()  // Update the list after deletion
            } catch {
                print("Failed to delete workout template: \(error.localizedDescription)")
            }
        }
    }
    
    // Colour related
    func createWorkoutTemplate(type: String, colour: UIColor) -> WorkoutTemplate? {
        let newWorkoutTemplate = controller.createWorkoutTemplate(type, colour: colour)
        getAllWorkoutTemplates()  // Update the list after creating
        return newWorkoutTemplate
    }

    func update(workoutTemplate: WorkoutTemplateModel, withNewInfo newInfo: WorkoutTemplateInfo, colour: UIColor) {
        if let existingWorkoutTemplate = controller.getWorkoutTemplateById(id: workoutTemplate.id) {
            controller.updateWorkoutTemplate(existingWorkoutTemplate: existingWorkoutTemplate, with: newInfo, colour: colour)
            getAllWorkoutTemplates()  // Update the list after updating
        }
    }

    func getColorForWorkoutTemplate(workoutTemplateId: NSManagedObjectID) -> UIColor? {
        let workoutTemplate = getWorkoutTemplate(id: workoutTemplateId)
        if let colourData = workoutTemplate.colour {
            return controller.convertDataToColor(data: colourData)
        }
        return nil
    }
}

