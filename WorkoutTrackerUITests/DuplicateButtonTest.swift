//
//  DuplicateButtonTest.swift
//  WorkoutTrackerUITests
//
//  Created by Madelaine Jones on 2024-02-11.
//

import Foundation
import XCTest

class DuplicateButtonUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        app.launch()
    }

    func testDuplicateButtonDisplay() throws {
        // Assuming the app starts with MainView and the first tab is "Workouts"
        let workoutsTab = app.tabBars.buttons["Workouts"]
        if workoutsTab.exists {
            workoutsTab.tap()
        }

        // Navigate to a specific workout where DuplicateButton might be present
        // This step is highly dependent on your app's data. You might need to tap on a specific workout.
        // For demonstration, let's assume you tap the first workout in the list.
        let firstWorkout = app.cells.element(boundBy: 0) // Adjust this to target the correct cell
        if firstWorkout.exists {
            firstWorkout.tap()
        }

        // If there's a list of exercises within the workout, tap the first one
        // Again, adjust this selector to match your UI hierarchy
        let firstExercise = app.cells.element(boundBy: 0) // Adjust this to target the correct cell
        if firstExercise.exists {
            firstExercise.tap()
        }

        // Now assuming we're at the screen that contains the DuplicateButton
        let duplicateButton = app.buttons["Duplicate"]
        XCTAssertTrue(duplicateButton.exists, "DuplicateButton does not exist.")

        // Verify accessibility label
        XCTAssertEqual(duplicateButton.label, "Duplicate", "DuplicateButton does not have the correct accessibility label.")
    }

}
