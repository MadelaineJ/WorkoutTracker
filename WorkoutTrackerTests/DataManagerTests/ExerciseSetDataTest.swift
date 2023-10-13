// ExerciseSetDataTests.swift
// WorkoutTrackerTests

import XCTest
import CoreData
@testable import WorkoutTracker

class ExerciseSetDataTests: XCTestCase {

    var dataManager: DataManager!
    var inTest: ExerciseSetData!
    
    override func setUpWithError() throws {
        // Set up an in-memory Core Data stack
        let container = NSPersistentContainer.inMemoryContainer
        let testDataManager = DataManager(container: container)
        inTest = ExerciseSetData(dataManager: testDataManager)
    }

    override func tearDownWithError() throws {
        inTest = nil
        dataManager = nil
    }
    
    func testCreateExerciseSet() {
        // Given
        let setInfo = ExerciseSetInfo(creationTime: Date(), weight: 100, reps: 10)
        
        // When
        inTest.createExerciseSet(setInfo)
        
        // Then
        let allSets = inTest.getAllSets()
        XCTAssertEqual(allSets.count, 1, "Should have one set after creation")
        XCTAssertEqual(allSets.first?.weight, setInfo.weight, "The created set's weight should match the provided weight")
        XCTAssertEqual(allSets.first?.reps, setInfo.reps, "The created set's reps should match the provided reps")
    }

    func testUpdateExerciseSet() {
        // Given
        let setInfo = ExerciseSetInfo(creationTime: Date(), weight: 100, reps: 10)
        inTest.createExerciseSet(setInfo)
        
        guard let existingSet = inTest.getAllSets().first else {
            XCTFail("There should be an existing set")
            return
        }
        
        let updatedInfo = ExerciseSetInfo(creationTime: Date(), weight: 150, reps: 8)
        
        // When
        inTest.updateExerciseSet(existingExerciseSet: existingSet, with: updatedInfo)
        
        // Then
        let updatedSet = inTest.getSetById(id: existingSet.objectID)
        XCTAssertEqual(updatedSet?.weight, updatedInfo.weight, "The updated set's weight should match the new weight")
        XCTAssertEqual(updatedSet?.reps, updatedInfo.reps, "The updated set's reps should match the new reps")
    }

    func testDeleteExerciseSet() {
        // Given
        let setInfo = ExerciseSetInfo(creationTime: Date(), weight: 100, reps: 10)
        inTest.createExerciseSet(setInfo)
        
        guard let existingSet = inTest.getAllSets().first else {
            XCTFail("There should be an existing set")
            return
        }
        
        // When
        inTest.deleteSet(exerciseSet: existingSet)
        
        // Then
        let allSets = inTest.getAllSets()
        XCTAssertEqual(allSets.count, 0, "Should have no sets after deletion")
    }

    func testGetAllSets() {
        // Given
        let setInfo1 = ExerciseSetInfo(creationTime: Date(), weight: 100, reps: 10)
        let setInfo2 = ExerciseSetInfo(creationTime: Date(), weight: 150, reps: 12)
        
        inTest.createExerciseSet(setInfo1)
        inTest.createExerciseSet(setInfo2)
        
        // When
        let allSets = inTest.getAllSets()
        
        // Then
        XCTAssertEqual(allSets.count, 2, "Should retrieve two sets")
    }

    func testGetSetById() {
        // Given
        let setInfo = ExerciseSetInfo(creationTime: Date(), weight: 100, reps: 10)
        inTest.createExerciseSet(setInfo)
        
        guard let existingSet = inTest.getAllSets().first else {
            XCTFail("There should be an existing set")
            return
        }
        
        // When
        let retrievedSet = inTest.getSetById(id: existingSet.objectID)
        
        // Then
        XCTAssertNotNil(retrievedSet, "Should retrieve a set by its ID")
        XCTAssertEqual(retrievedSet?.weight, setInfo.weight, "The retrieved set's weight should match the original weight")
        XCTAssertEqual(retrievedSet?.reps, setInfo.reps, "The retrieved set's reps should match the original reps")
    }

}

extension ExerciseSetData {
    convenience init(dataManager: DataManager) {
        self.init()
        self.dataManager = dataManager
    }
}
