//
//  WorkoutTemplateViewModelTest.swift
//  WorkoutTrackerTests
//
//  Created by Madelaine Jones on 2024-01-06.
//

import XCTest
@testable import WorkoutTracker
import CoreData

class WorkoutTemplateViewModelTests: XCTestCase {

    var viewModel: WorkoutTemplateViewModel!
    var exerciseViewModel: ExerciseTemplateViewModel!
    var mockWorkoutTemplateData: WorkoutTemplateData!
    var mockExerciseTemplateData: ExerciseTemplateData!
    var mockWorkoutViewModel: WorkoutViewModel!
    var mockWorkoutData: WorkoutData!
    var mockExerciseViewModel: ExerciseViewModel!

    override func setUpWithError() throws {
        let testDataManager = DataManager(container: NSPersistentContainer.inMemoryContainer)
        mockWorkoutTemplateData = WorkoutTemplateData(dataManager: testDataManager)
        mockExerciseTemplateData = ExerciseTemplateData(dataManager: testDataManager)
        mockWorkoutData = WorkoutData(dataManager: testDataManager)
        mockWorkoutViewModel = WorkoutViewModel(controller: mockWorkoutData)
        mockExerciseViewModel = ExerciseViewModel()
        viewModel = WorkoutTemplateViewModel(controller: mockWorkoutTemplateData,
                                             exerciseController: mockExerciseTemplateData,
                                             workoutViewModel: mockWorkoutViewModel)
        exerciseViewModel = ExerciseTemplateViewModel(controller: mockExerciseTemplateData)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockWorkoutTemplateData = nil
        mockExerciseTemplateData = nil
        mockWorkoutViewModel = nil
        mockExerciseViewModel = nil
    }

    func testCreateWorkoutTemplate() {
        _ = viewModel.createWorkoutTemplate(type: "Strength")
        viewModel.getAllWorkoutTemplates()

        XCTAssertEqual(viewModel.workoutTemplates.count, 1)
        XCTAssertEqual(viewModel.workoutTemplates.first?.type, "Strength")
    }

    func testGetWorkoutTemplate() {
        guard let workoutTemplate = viewModel.createWorkoutTemplate(type: "Strength") else {
            XCTFail("Workout template creation failed")
            return
        }
        let retrievedTemplate = viewModel.getWorkoutTemplate(id: workoutTemplate.objectID)

        XCTAssertEqual(retrievedTemplate.type, "Strength")
    }

    func testGetAllWorkoutTemplates() {
        _ = viewModel.createWorkoutTemplate(type: "Strength")
        _ = viewModel.createWorkoutTemplate(type: "Cardio")
        viewModel.getAllWorkoutTemplates()

        XCTAssertEqual(viewModel.workoutTemplates.count, 2)
    }

    func testGetExercisesForWorkout() {
        let workoutTemplate = viewModel.createWorkoutTemplate(type: "Strength")!
        // Assume ExerciseTemplateModel and its creation is handled similarly
        let exerciseTemplate = exerciseViewModel.createExerciseTemplate(name: "Push-ups")
        mockExerciseTemplateData.addExerciseTemplate(workoutId: workoutTemplate.objectID, exerciseTemplate: exerciseTemplate)
        
        let exercises = viewModel.getExercisesForWorkout(workoutTemplate: WorkoutTemplateModel(workout: workoutTemplate))

        XCTAssertEqual(exercises.count, 1)
        XCTAssertEqual(exercises.first?.name, "Push-ups")
    }

    func testDeleteWorkoutTemplate() {
        guard let workoutTemplate = viewModel.createWorkoutTemplate(type: "Strength") else {
            XCTFail("Workout template creation failed")
            return
        }
        viewModel.getAllWorkoutTemplates()
        
        viewModel.delete(WorkoutTemplateModel(workout: workoutTemplate))
        
        viewModel.getAllWorkoutTemplates()
        XCTAssertEqual(viewModel.workoutTemplates.count, 0)
    }

    func testCreateWorkoutTemplateWithColor() {
        let color = UIColor.red
        _ = viewModel.createWorkoutTemplate(type: "Cardio", colour: color)
        viewModel.getAllWorkoutTemplates()

        guard let createdTemplate = viewModel.workoutTemplates.first else {
            XCTFail("Workout template creation failed")
            return
        }
        
        let retrievedColor = viewModel.getColorForWorkoutTemplate(workoutTemplateId: createdTemplate.id)
        XCTAssertEqual(createdTemplate.type, "Cardio")
        XCTAssertEqual(retrievedColor, color)
    }

    func testUpdateWorkoutTemplate() {
        guard let workoutTemplate = viewModel.createWorkoutTemplate(type: "Strength") else {
            XCTFail("Workout template creation failed")
            return
        }
        let newInfo = WorkoutTemplateInfo(type: "Updated Strength")
        let newColor = UIColor.blue

        viewModel.update(workoutTemplate: WorkoutTemplateModel(workout: workoutTemplate), withNewInfo: newInfo, colour: newColor)
        viewModel.getAllWorkoutTemplates()
        
        guard let updatedTemplate = viewModel.workoutTemplates.first(where: { $0.id == workoutTemplate.objectID }) else {
            XCTFail("Workout template not found after update")
            return
        }

        XCTAssertEqual(updatedTemplate.type, "Updated Strength")
        XCTAssertEqual(viewModel.getColorForWorkoutTemplate(workoutTemplateId: updatedTemplate.id), newColor)
    }

    func testGetAssociatedWorkouts() {
        // Create a workout template and a workout that uses this template
        guard let workoutTemplate = viewModel.createWorkoutTemplate(type: "Strength") else {
            XCTFail("Workout template creation failed")
            return
        }
        _ = mockWorkoutViewModel.createWorkout(type: "Strength", template: workoutTemplate)

        let associatedWorkouts = viewModel.getAssociatedWorkouts(templateId: workoutTemplate.objectID)
        XCTAssertEqual(associatedWorkouts.count, 1)
        XCTAssertEqual(associatedWorkouts.first?.template?.objectID, workoutTemplate.objectID)
    }

    func testGetColorForWorkoutTemplate() {
        let color = UIColor.green
        guard let workoutTemplate = viewModel.createWorkoutTemplate(type: "Strength", colour: color) else {
            XCTFail("Workout template creation failed")
            return
        }

        let retrievedColor = viewModel.getColorForWorkoutTemplate(workoutTemplateId: workoutTemplate.objectID)
        XCTAssertEqual(retrievedColor, color)
    }

    func testCreateWorkoutFromTemplate() {
        guard let workoutTemplate = viewModel.createWorkoutTemplate(type: "Strength", colour: UIColor.blue) else {
            XCTFail("Workout template creation failed")
            return
        }
        let workout = viewModel.createWorkoutFromTemplate(workoutTemplate: WorkoutTemplateModel(workout: workoutTemplate))

        XCTAssertEqual(workout.type, "Strength")
        XCTAssertEqual(viewModel.getColorForWorkoutTemplate(workoutTemplateId: workout.template!.objectID), UIColor.blue)
    }

}

