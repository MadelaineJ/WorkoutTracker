//
//  ColourExtentionTest.swift
//  WorkoutTrackerTests
//
//  Created by Madelaine Jones on 2024-01-05.
//

import XCTest
@testable import WorkoutTracker
import SwiftUI

class ColorExtensionTests: XCTestCase {

    // Mock colors to test the methods
    let red = Color.red
    let green = Color.green
    let blue = Color.blue
    let black = Color.black
    let white = Color.white

    func testLuminanceForBlackColor() {
        let luminance = black.luminance()
        XCTAssertEqual(luminance, 0, accuracy: 0.01)
    }

    func testLuminanceForWhiteColor() {
        let luminance = white.luminance()
        XCTAssertEqual(luminance, 1, accuracy: 0.01)
    }

    func testLuminanceForRedColor() {
        let luminance = red.luminance()
        // Use the value you obtained from your test execution
        XCTAssertEqual(luminance, 0.4563, accuracy: 0.01)
    }

    func testLuminanceForGreenColor() {
        let luminance = green.luminance()
        // Use the value you obtained from your test execution
        XCTAssertEqual(luminance, 0.5589, accuracy: 0.01)
    }

    func testContrastingTextColorForDarkColor() {
        let contrastingColor = black.contrastingTextColor()
        let uiColor = UIColor(contrastingColor)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let isWhite = red > 0.99 && green > 0.99 && blue > 0.99 // checking that the colour is close to white
        XCTAssertTrue(isWhite, "Expected white color")
    }

    func testContrastingTextColorForLightColor() {
        let contrastingColor = white.contrastingTextColor()
        let uiColor = UIColor(contrastingColor)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        XCTAssertTrue(red == 0 && green == 0 && blue == 0, "Expected black color")
    }

    func testContrastingTextColorForRedColor() {
        let contrastingColor = red.contrastingTextColor()
        let uiColor = UIColor(contrastingColor)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let isWhite = red > 0.99 && green > 0.99 && blue > 0.99
        XCTAssertTrue(isWhite, "Expected white color")
    }

    func testIsWhiteOrVeryLightForWhiteColor() {
        XCTAssertTrue(white.isWhiteOrVeryLight())
    }

    func testIsWhiteOrVeryLightForRedColor() {
        XCTAssertFalse(red.isWhiteOrVeryLight())
    }

    func testAdjustLightnessForSpecificColor() {
        let adjustmentAmount: CGFloat = 0.5
        let originalUIColor = UIColor(green)  // Convert SwiftUI Color to UIKit UIColor
        let originalColor = Color(originalUIColor) // Convert UIColor to SwiftUI Color

        var originalHue: CGFloat = 0
        var originalSaturation: CGFloat = 0
        var originalBrightness: CGFloat = 0
        var originalAlpha: CGFloat = 0
        originalUIColor.getHue(&originalHue, saturation: &originalSaturation, brightness: &originalBrightness, alpha: &originalAlpha)

        let adjustedColor = originalColor.adjustLightness(by: adjustmentAmount)
        let adjustedUIColor = UIColor(adjustedColor) // Convert adjusted SwiftUI Color back to UIColor
        var adjustedHue: CGFloat = 0
        var adjustedSaturation: CGFloat = 0
        var adjustedBrightness: CGFloat = 0
        var adjustedAlpha: CGFloat = 0
        adjustedUIColor.getHue(&adjustedHue, saturation: &adjustedSaturation, brightness: &adjustedBrightness, alpha: &adjustedAlpha)

        // Expected new brightness is the original brightness plus the adjustment amount, but not exceeding 1
        let expectedBrightness = min(originalBrightness + adjustmentAmount, 1)
        
        XCTAssertEqual(adjustedBrightness, expectedBrightness, accuracy: 0.01, "The brightness of the adjusted color should be as expected")
    }

    func testIsLightColorForDarkColor() {
        XCTAssertFalse(black.isLightColor())
    }

    func testIsLightColorForLightColor() {
        XCTAssertTrue(white.isLightColor())
    }
}
