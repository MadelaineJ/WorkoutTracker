//
//  WorkoutTemplateData.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-28.
//
import CoreData

class WorkoutTemplateData {
    var dataManager: DataManager

    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }

    func createWorkoutTemplate(_ type: String) {
        let workoutTemplate = WorkoutTemplate(context: dataManager.viewContext)
        workoutTemplate.type = type
        dataManager.save()
    }

    func updateWorkoutTemplate(existingWorkoutTemplate: WorkoutTemplate, with newInfo: String) {
        existingWorkoutTemplate.type = newInfo

        dataManager.save()
    }

    func getAllWorkoutTemplates() -> [WorkoutTemplate] {
        let request: NSFetchRequest<WorkoutTemplate> = WorkoutTemplate.fetchRequest()
        
        // Add a sort descriptor to sort by creationTime in descending order
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try dataManager.viewContext.fetch(request)
        } catch {
            return []
        }
    }

    func getWorkoutTemplateById(id: NSManagedObjectID) -> WorkoutTemplate? {
        
        do {
            return try dataManager.viewContext.existingObject(with: id) as? WorkoutTemplate
        } catch {
            return nil
        }
    }

    func deleteWorkoutTemplate(workoutTemplate: WorkoutTemplate) throws {
        dataManager.viewContext.delete(workoutTemplate)
        try dataManager.viewContext.save()
    }
}
    

