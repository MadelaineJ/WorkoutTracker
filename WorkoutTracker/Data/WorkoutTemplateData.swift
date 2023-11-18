//
//  WorkoutTemplateData.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-28.
//
import CoreData
import UIKit

class WorkoutTemplateData {
    var dataManager: DataManager

    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }

    func createWorkoutTemplate(_ type: String) -> WorkoutTemplate {
        let workoutTemplate = WorkoutTemplate(context: dataManager.viewContext)
        workoutTemplate.type = type
        dataManager.save()
        return workoutTemplate
    }

    func updateWorkoutTemplate(existingWorkoutTemplate: WorkoutTemplate, with newInfo: WorkoutTemplateInfo) {
        existingWorkoutTemplate.type = newInfo.type

        dataManager.save()
    }

    func getAllWorkoutTemplates() -> [WorkoutTemplate] {
        let request: NSFetchRequest<WorkoutTemplate> = WorkoutTemplate.fetchRequest()
        
        // Add a sort descriptor to sort by creationTime in descending order
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: true)
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
    
    func convertColorToData(color: UIColor) -> Data {
            return try! NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        }

    func convertDataToColor(data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }

    func createWorkoutTemplate(_ type: String, color: UIColor) -> WorkoutTemplate {
        let workoutTemplate = WorkoutTemplate(context: dataManager.viewContext)
        workoutTemplate.type = type
        workoutTemplate.color = convertColorToData(color: color)  // Save color as Data
        dataManager.save()
        return workoutTemplate
    }

    func updateWorkoutTemplate(existingWorkoutTemplate: WorkoutTemplate, with newInfo: WorkoutTemplateInfo, color: UIColor) {
        existingWorkoutTemplate.type = newInfo.type
        existingWorkoutTemplate.color = convertColorToData(color: color)  // Update color
        dataManager.save()
    }
}
