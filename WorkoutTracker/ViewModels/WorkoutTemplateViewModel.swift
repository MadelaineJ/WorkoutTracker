//
//  WorkoutTemplateViewModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-28.
//

import Foundation
import CoreData
import Combine  // If you are using Combine for @Published property

class WorkoutTemplateViewModel: ObservableObject {

    var controller: WorkoutTemplateData  // Adjust this to the type name if it's different

    init(controller: WorkoutTemplateData = WorkoutTemplateData()) {
        self.controller = controller
    }

    var type = ""
    @Published var workoutTemplates: [WorkoutTemplateModel] = []  // Assuming you have a WorkoutTemplateModel similar to WorkoutModel

    func createWorkoutTemplate(type: String) {
        controller.createWorkoutTemplate(type)
        getAllWorkoutTemplates()  // Update the list after creating
    }

    func update(workoutTemplate: WorkoutTemplateModel, withNewInfo newInfo: String) {
        if let existingWorkoutTemplate = controller.getWorkoutTemplateById(id: workoutTemplate.id) {
            controller.updateWorkoutTemplate(existingWorkoutTemplate: existingWorkoutTemplate, with: newInfo)
            getAllWorkoutTemplates()  // Update the list after updating
        }
    }

    func getAllWorkoutTemplates() {
        workoutTemplates = controller.getAllWorkoutTemplates().map(WorkoutTemplateModel.init)  // Assuming you have a similar initializer in WorkoutTemplateModel
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


    // Add other functions as per your needs, similar to how you have in the WorkoutViewModel
}

