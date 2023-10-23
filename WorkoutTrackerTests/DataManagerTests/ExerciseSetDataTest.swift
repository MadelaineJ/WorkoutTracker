// ExerciseSetDataTests.swift
// WorkoutTrackerTests

import XCTest
import CoreData
@testable import WorkoutTracker

// ExerciseSetDataTests.swift
// WorkoutTrackerTests

import XCTest
import CoreData
@testable import WorkoutTracker

class ExerciseSetDataTests: XCTestCase {
    var dataManager: DataManager!
    var inTest: ExerciseSetData!
    var exerciseData: ExerciseData!

    override func setUpWithError() throws {
        dataManager = DataManager(container: NSPersistentContainer.inMemoryContainer)
        inTest = ExerciseSetData(dataManager: dataManager)
        exerciseData = ExerciseData(dataManager: dataManager)
    }

    override func tearDownWithError() throws {
        dataManager = nil
        inTest = nil
        exerciseData = nil
    }
    
    func testCreateExerciseSet() {
        let setInfo = ExerciseSetInfo(creationTime: Date(), weight: Int64(50.0), reps: 10)
        let exerciseSet = inTest.createExerciseSet(setInfo)
        
        XCTAssertNotNil(exerciseSet)
        XCTAssertEqual(exerciseSet.creationTime, setInfo.creationTime)
        XCTAssertEqual(exerciseSet.weight, setInfo.weight)
        XCTAssertEqual(exerciseSet.reps, setInfo.reps)
    }
    
    func testUpdateExerciseSet() {
        // Create a set
        let initialSetInfo = ExerciseSetInfo(creationTime: Date(), weight: Int64(50.0), reps: 10)
        let exerciseSet = inTest.createExerciseSet(initialSetInfo)
        
        // Update the set
        let newInfo = ExerciseSetInfo(creationTime: Date(), weight: Int64(60.0), reps: 12)
        inTest.updateExerciseSet(existingExerciseSet: exerciseSet, with: newInfo)
        
        XCTAssertEqual(exerciseSet.weight, newInfo.weight)
        XCTAssertEqual(exerciseSet.reps, newInfo.reps)
    }
    
    func testFetchAllExerciseSets() {
        let setInfo1 = ExerciseSetInfo(creationTime: Date(), weight: 50, reps: 10)
        let setInfo2 = ExerciseSetInfo(creationTime: Date(), weight: 60, reps: 12)
        
        _ = inTest.createExerciseSet(setInfo1)
        _ = inTest.createExerciseSet(setInfo2)
        
        let allSets = inTest.getAllSets()
        
        XCTAssertEqual(allSets.count, 2)
    }
    
    func testFetchExerciseSetsByExerciseId() {
        // Create an exercise
        let exerciseInfo = ExerciseInfo(creationTime: Date(), name: "Squats")
        let exercise = exerciseData.createExercise(exerciseInfo)

        // Create a set
        let setInfo = ExerciseSetInfo(creationTime: Date(), weight: 50, reps: 10)
        let exerciseSet = inTest.createExerciseSet(setInfo)

        // Add the set to the exercise
        inTest.addExerciseSet(exerciseId: exercise.objectID, exerciseSet: exerciseSet)

        // Fetch the sets for the exercise
        let fetchedSets = inTest.getExerciseSets(exerciseId: exercise.objectID)

        XCTAssertEqual(fetchedSets.count, 1)
        XCTAssertEqual(fetchedSets.first?.weight, setInfo.weight)
        XCTAssertEqual(fetchedSets.first?.reps, setInfo.reps)
    }


    func testFetchExerciseSetById() {
        let setInfo = ExerciseSetInfo(creationTime: Date(), weight: 50, reps: 10)
        let createdSet = inTest.createExerciseSet(setInfo)
        
        let fetchedSet = inTest.getSetById(id: createdSet.objectID)
        
        XCTAssertNotNil(fetchedSet)
        XCTAssertEqual(fetchedSet?.weight, setInfo.weight)
        XCTAssertEqual(fetchedSet?.reps, setInfo.reps)
    }

    func testAddExerciseSetToExercise() {
        // Create an exercise
        let exerciseInfo = ExerciseInfo(creationTime: Date(), name: "Bench Press")
        let exercise = exerciseData.createExercise(exerciseInfo)

        // Create a set
        let setInfo = ExerciseSetInfo(creationTime: Date(), weight: 50, reps: 10)
        let exerciseSet = inTest.createExerciseSet(setInfo)

        // Add the set to the exercise
        inTest.addExerciseSet(exerciseId: exercise.objectID, exerciseSet: exerciseSet)

        // Fetch the sets for the exercise
        let fetchedSets = inTest.getExerciseSets(exerciseId: exercise.objectID)

        XCTAssertEqual(fetchedSets.count, 1)
    }


    
    func testDeleteExerciseSet() {
        let setInfo = ExerciseSetInfo(creationTime: Date(), weight: 50, reps: 10)
        let createdSet = inTest.createExerciseSet(setInfo)
        
        XCTAssertEqual(inTest.getAllSets().count, 1)
        
        inTest.deleteSet(exerciseSet: createdSet)
        
        XCTAssertEqual(inTest.getAllSets().count, 0)
    }


}

