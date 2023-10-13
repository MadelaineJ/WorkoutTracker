//
//  ExerciseDataTests.swift
//  ExerciseTrackerTests
//
//  Created by Madelaine Jones on 2023-10-08.
//

import XCTest
import CoreData
@testable import WorkoutTracker


class ExerciseDataTests: XCTestCase {

    var dataManager: DataManager!
    var inTest: ExerciseData!
    
    override func setUpWithError() throws {
        // Set up an in-memory Core Data stack
        let container = NSPersistentContainer.inMemoryContainer
        let testDataManager = DataManager(container: container)
        inTest = ExerciseData(dataManager: testDataManager)
    }

    override func tearDownWithError() throws {
        inTest = nil
        dataManager = nil
    }
    
    func testCreateExercise() {
        // Given
        let exerciseInfo = ExerciseInfo(creationTime: Date(), name: "Squat")
        
        // When
        inTest.createExercise(exerciseInfo)
        
        // Then
        let allExercises = inTest.getAllExercises()
        XCTAssertEqual(allExercises.count, 1, "Should have one exercise after creation")
        XCTAssertEqual(allExercises.first?.name, exerciseInfo.name, "The created exercise's name should match the provided name")
    }
    
    func testUpdateExercise() {
        // Given
        let exerciseInfo = ExerciseInfo(creationTime: Date(), name: "Squat")
        inTest.createExercise(exerciseInfo)
        
        guard let existingExercise = inTest.getAllExercises().first else {
            XCTFail("There should be an existing exercise")
            return
        }
        
        let updatedInfo = ExerciseInfo(creationTime: Date(), name: "Deadlift")
        
        // When
        inTest.updateExercise(existingExercise: existingExercise, with: updatedInfo)
        
        // Then
        let updatedExercise = inTest.getExerciseById(id: existingExercise.objectID)
        XCTAssertEqual(updatedExercise?.name, updatedInfo.name, "The updated exercise's name should match the new name")
    }
    
    func testDeleteExercise() {
        // Given
        let exerciseInfo = ExerciseInfo(creationTime: Date(), name: "Squat")
        inTest.createExercise(exerciseInfo)
        
        guard let existingExercise = inTest.getAllExercises().first else {
            XCTFail("There should be an existing exercise")
            return
        }
        
        // When
        inTest.deleteExercise(exercise: existingExercise)
        
        // Then
        let allExercises = inTest.getAllExercises()
        XCTAssertEqual(allExercises.count, 0, "Should have no exercises after deletion")
    }
    
    func testGetAllExercises() {
        // Given
        let exerciseInfo1 = ExerciseInfo(creationTime: Date(), name: "Squat")
        let exerciseInfo2 = ExerciseInfo(creationTime: Date(), name: "Deadlift")
        
        inTest.createExercise(exerciseInfo1)
        inTest.createExercise(exerciseInfo2)
        
        // When
        let allExercises = inTest.getAllExercises()
        
        // Then
        XCTAssertEqual(allExercises.count, 2, "Should retrieve two exercises")
    }
    
    func testGetExerciseById() {
        // Given
        let exerciseInfo = ExerciseInfo(creationTime: Date(), name: "Squat")
        inTest.createExercise(exerciseInfo)
        
        guard let existingExercise = inTest.getAllExercises().first else {
            XCTFail("There should be an existing exercise")
            return
        }
        
        // When
        let retrievedExercise = inTest.getExerciseById(id: existingExercise.objectID)
        
        // Then
        XCTAssertNotNil(retrievedExercise, "Should retrieve an exercise by its ID")
        XCTAssertEqual(retrievedExercise?.name, exerciseInfo.name, "The retrieved exercise's name should match the original name")
    }
}

extension ExerciseData {
    convenience init(dataManager: DataManager) {
        self.init()
        self.dataManager = dataManager
    }
}
