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
import SwiftUI

class WorkoutTemplateViewModel: ObservableObject {
    var controller: WorkoutTemplateData
    var exerciseController: ExerciseTemplateData
    var workoutViewModel: WorkoutViewModel
    var exerciseViewModel: ExerciseViewModel = ExerciseViewModel()

    init(controller: WorkoutTemplateData = WorkoutTemplateData(),
         exerciseController: ExerciseTemplateData = ExerciseTemplateData(),
         workoutViewModel: WorkoutViewModel = WorkoutViewModel()
    ) {
        self.controller = controller
        self.exerciseController = exerciseController
        self.workoutViewModel = workoutViewModel
    }

    var type = ""
    @Published var workoutTemplates: [WorkoutTemplateModel] = []

    func createWorkoutTemplate(type: String) -> WorkoutTemplate? {
        let newWorkoutTemplate = controller.createWorkoutTemplate(type)
        getAllWorkoutTemplates()  // Update the list after creating
        return newWorkoutTemplate
    }

//    func update(workoutTemplate: WorkoutTemplateModel, withNewInfo newInfo: WorkoutTemplateInfo) {
//        if let existingWorkoutTemplate = controller.getWorkoutTemplateById(id: workoutTemplate.id) {
//            controller.updateWorkoutTemplate(existingWorkoutTemplate: existingWorkoutTemplate, with: newInfo)
//            getAllWorkoutTemplates()  // Update the list after updating
//        }
//    }
    
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

    func update(workoutTemplate: WorkoutTemplateModel, withNewInfo newInfo: WorkoutTemplateInfo, colour: UIColor = UIColor.systemGray6) {
        if let existingWorkoutTemplate = controller.getWorkoutTemplateById(id: workoutTemplate.id) {
            controller.updateWorkoutTemplate(existingWorkoutTemplate: existingWorkoutTemplate, with: newInfo, colour: nil)
            
            if let template = controller.getWorkoutTemplateById(id: workoutTemplate.id) {
                for workout in getAssociatedWorkouts(templateId: workoutTemplate.id) {
                    let info = WorkoutInfo(creationTime: workout.creationTime, type: template.type ?? "", template: template)
                    workoutViewModel.update(workout: workout, withNewInfo: info)
                }
            }
            workoutViewModel.getAllWorkouts()
            workoutViewModel.groupedWorkoutsByMonth()
            getAllWorkoutTemplates()  // Update the list after updating

        }
        
    }
    
    func getAssociatedWorkouts(templateId: NSManagedObjectID) -> [WorkoutModel]  {

        let associatedWorkouts = workoutViewModel.workouts.filter { workout in
            guard let workoutTemplateId = workout.template?.objectID else {
                return false
            }
            return workoutTemplateId == templateId
        }
        print(associatedWorkouts.count)
        return associatedWorkouts
    }

    func getColorForWorkoutTemplate(workoutTemplateId: NSManagedObjectID) -> UIColor? {
        let workoutTemplate = getWorkoutTemplate(id: workoutTemplateId)
        if let colourData = workoutTemplate.colour {
            return controller.convertDataToColor(data: colourData)
        }
        return nil
    }
    
    func createWorkoutFromTemplate(workoutTemplate: WorkoutTemplateModel) -> Workout {
        // Create a workout using information from the workout template
        let workoutType = workoutTemplate.type
        let colour = workoutTemplate.colour
        let template = getWorkoutTemplate(id: workoutTemplate.id)
        let workout = workoutViewModel.createWorkout(type: workoutType, colorData: colour, template: template)

                
        if let unwrappedExercises = template.exercises {
            for exerciseTemplate in unwrappedExercises.allObjects as! [ExerciseTemplate] {
                _ = exerciseViewModel.addExercise(id: workout.objectID, name: exerciseTemplate.name!)
            }
        }
        
        return workout
    }
}

