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
    
    func convertColorToData(colour: UIColor) -> Data {
            return try! NSKeyedArchiver.archivedData(withRootObject: colour, requiringSecureCoding: false)
    }

    func convertDataToColor(data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }

    func createWorkoutTemplate(_ type: String, colour: UIColor) -> WorkoutTemplate {
        let workoutTemplate = WorkoutTemplate(context: dataManager.viewContext)
        workoutTemplate.type = type
        workoutTemplate.colour = convertColorToData(colour: colour)  // Save color as Data
        dataManager.save()
        return workoutTemplate
    }

    func updateWorkoutTemplate(existingWorkoutTemplate: WorkoutTemplate, with newInfo: WorkoutTemplateInfo, colour: UIColor?) {
        existingWorkoutTemplate.type = newInfo.type
        if let colour = colour {
            existingWorkoutTemplate.colour = convertColorToData(colour: colour)  // Update color
        }
        
        dataManager.save()
    }
}
