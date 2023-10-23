//
//  ExerciseSetViewModelTest.swift
//  WorkoutTrackerTests
//
//  Created by Madelaine Jones on 2023-10-22.
//

import XCTest
import CoreData
@testable import WorkoutTracker

class ExerciseSetViewModelTests: XCTestCase {

    var viewModel: ExerciseSetViewModel!
    var mockExerciseSetData: ExerciseSetData!
    var mockExerciseData: ExerciseData!

    override func setUpWithError() throws {
        // Create an in-memory Core Data stack
        let testDataManager = DataManager(container: NSPersistentContainer.inMemoryContainer)
        mockExerciseSetData = ExerciseSetData(dataManager: testDataManager)
        mockExerciseData = ExerciseData(dataManager: testDataManager)
        viewModel = ExerciseSetViewModel(controller: mockExerciseSetData)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockExerciseSetData = nil
        mockExerciseData = nil
    }

    func testCreateExerciseSet() {
        viewModel.weight = "50"
        viewModel.reps = "10"
        _ = viewModel.createExerciseSet()
        viewModel.getAllSets()

        XCTAssertEqual(viewModel.exerciseSets.count, 1)
        XCTAssertEqual(viewModel.exerciseSets.first?.weight, 50)
        XCTAssertEqual(viewModel.exerciseSets.first?.reps, 10)
    }

    func testUpdateExerciseSet() {
        viewModel.weight = "50"
        viewModel.reps = "10"
        let exerciseSet = viewModel.createExerciseSet()
        viewModel.getAllSets()
        let updatedInfo = ExerciseSetInfo(creationTime: Date(), weight: 60, reps: 8)
        viewModel.update(exerciseSet: SetModel(exerciseSet: exerciseSet), withNewInfo: updatedInfo)
        viewModel.getAllSets()

        XCTAssertEqual(viewModel.exerciseSets.first?.weight, 60)
        XCTAssertEqual(viewModel.exerciseSets.first?.reps, 8)
    }

    func testGetAllSets() {
        viewModel.weight = "50"
        viewModel.reps = "10"
        _ = viewModel.createExerciseSet()
        viewModel.weight = "60"
        viewModel.reps = "8"
        _ = viewModel.createExerciseSet()
        viewModel.getAllSets()

        XCTAssertEqual(viewModel.exerciseSets.count, 2)
    }

    func testGetExerciseSetsByExercise() {
        let exerciseInfo = ExerciseInfo(creationTime: Date(), name: "Squats")
        let exercise = mockExerciseData.createExercise(exerciseInfo)
        viewModel.weight = "50"
        viewModel.reps = "10"
        _ = viewModel.createExerciseSet()
        let exerciseSet = viewModel.createExerciseSet()
        mockExerciseSetData.addExerciseSet(exerciseId: exercise.objectID, exerciseSet: exerciseSet)

        viewModel.getExerciseSets(exercise: ExerciseModel(exercise: exercise))

        XCTAssertEqual(viewModel.exerciseSets.count, 1)
    }

    func testAddExerciseSetToExercise() {
        let exerciseInfo = ExerciseInfo(creationTime: Date(), name: "Squats")
        let exercise = mockExerciseData.createExercise(exerciseInfo)
        viewModel.weight = "50"
        viewModel.reps = "10"
        viewModel.addExerciseSet(exercise: ExerciseModel(exercise: exercise))
        
        viewModel.getExerciseSets(exercise: ExerciseModel(exercise: exercise))

        XCTAssertEqual(viewModel.exerciseSets.count, 1)
    }

    func testDeleteExerciseSet() {
        viewModel.weight = "50"
        viewModel.reps = "10"
        let exerciseSet = viewModel.createExerciseSet()
        viewModel.getAllSets()
        
        viewModel.delete(SetModel(exerciseSet: exerciseSet))
        
        viewModel.getAllSets()
        XCTAssertEqual(viewModel.exerciseSets.count, 0)
    }
}
