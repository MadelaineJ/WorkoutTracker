//
//  ExerciseTemplateTest.swift
//  WorkoutTrackerTests
//
//  Created by Madelaine Jones on 2023-10-28.
//

import XCTest
import CoreData
@testable import WorkoutTracker

class ExerciseTemplateDataTests: XCTestCase {

    var inTest: ExerciseTemplateData!

    override func setUpWithError() throws {
        let container = NSPersistentContainer.inMemoryContainer
        let testDataManager = DataManager(container: container)
        inTest = ExerciseTemplateData(dataManager: testDataManager)
    }

    override func tearDownWithError() throws {
        inTest = nil
    }

    func testCreateExerciseTemplate() {
        // Given
        let exerciseName = "Push-up"
        
        // When
        let exerciseTemplate = inTest.createExerciseTemplate(exerciseName)
        
        // Then
        XCTAssertEqual(exerciseTemplate.name, exerciseName, "The created exercise's name should match the provided name")
    }

    func testUpdateExerciseTemplate() {
        // Given
        let initialName = "Push-up"
        let newName = "Sit-up"
        
        let exerciseTemplate = inTest.createExerciseTemplate(initialName)
        
        // When
        inTest.updateExerciseTemplate(existingExerciseTemplate: exerciseTemplate, with: newName)
        
        // Then
        XCTAssertEqual(exerciseTemplate.name, newName, "The updated exercise's name should match the new name")
    }

    func testGetAllExerciseTemplates() {
        // Given
        let exerciseName1 = "Push-up"
        let exerciseName2 = "Sit-up"
        
        _ = inTest.createExerciseTemplate(exerciseName1)
        _ = inTest.createExerciseTemplate(exerciseName2)
        
        // When
        let allExerciseTemplates = inTest.getAllExerciseTemplates()
        
        // Then
        XCTAssertEqual(allExerciseTemplates.count, 2, "Should retrieve two exercise templates")
    }

    func testDeleteExerciseTemplate() {
        // Given
        let exerciseName = "Push-up"
        let exerciseTemplate = inTest.createExerciseTemplate(exerciseName)
        
        // When
        inTest.deleteExerciseTemplate(exerciseTemplate: exerciseTemplate)
        
        // Then
        let allExerciseTemplates = inTest.getAllExerciseTemplates()
        XCTAssertEqual(allExerciseTemplates.count, 0, "Should have no exercise templates after deletion")
    }
}

