//
//  SetViewModel.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-07.
//

import Foundation
import CoreData

class ExerciseSetViewModel: ObservableObject {
    
    var controller: ExerciseSetData

    init(controller: ExerciseSetData = ExerciseSetData.controller) {
        self.controller = controller
    }
    
    var weight = ""
    var reps = ""
    @Published var exerciseSets: [SetModel] = []
    
    func createExerciseSet() {
        let exerciseSet = ExerciseSet(context: DataManager.shared.persistentContainer.viewContext)
        exerciseSet.creationTime = Date()
        exerciseSet.weight = Int64(weight) ?? 0
        exerciseSet.reps = Int64(reps) ?? 0
        
        DataManager.shared.save()
    }
    
    func update(exerciseSet: SetModel, withNewInfo newInfo: ExerciseSetInfo) {
        let existingExerciseSet = controller.getSetById(id: exerciseSet.id)
        if let existingExerciseSet = existingExerciseSet {
            controller.updateExerciseSet(existingExerciseSet: existingExerciseSet, with: newInfo)
        }
    }
    func getAllSets() {
        exerciseSets = controller.getAllSets().map(SetModel.init)
    }
    
    func getExerciseSets() {
        exerciseSets = controller.getAllSets().map(SetModel.init)
    }
    
    func delete(_ exerciseSet: SetModel) {
        let existingSet = controller.getSetById(id: exerciseSet.id)
        if let existingSet = existingSet {
            controller.deleteSet(exerciseSet: existingSet)
        }
    }
}
