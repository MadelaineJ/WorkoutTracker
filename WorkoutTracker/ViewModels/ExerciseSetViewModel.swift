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

    init(controller: ExerciseSetData = ExerciseSetData()) {
        self.controller = controller
    }
    
    var weight = "0"
    var reps = "0"
    @Published var exerciseSets: [SetModel] = []
    
    func createExerciseSet() -> ExerciseSet {
        let exerciseSet = controller.createExerciseSet(
            ExerciseSetInfo(creationTime: Date(), weight: Int64(weight) ?? 0, reps: Int64(reps) ?? 0))

        return exerciseSet
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
    
    func getExerciseSets(exercise: ExerciseModel) {
        exerciseSets = controller.getExerciseSets(exerciseId: exercise.id).map(SetModel.init)
    }
    
    func addExerciseSet(exercise: ExerciseModel) {
        let exerciseSet = createExerciseSet()
        controller.addExerciseSet(exerciseId: exercise.id, exerciseSet: exerciseSet)
    }
    
    func delete(_ exerciseSet: SetModel) {
        let existingSet = controller.getSetById(id: exerciseSet.id)
        if let existingSet = existingSet {
            controller.deleteSet(exerciseSet: existingSet)
        }
    }
}
