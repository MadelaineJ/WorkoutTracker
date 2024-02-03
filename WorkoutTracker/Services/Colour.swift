//
//  Colour.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-11-25.
//

import SwiftUI

extension Color {
    func luminance() -> Double {
        let uiColor = UIColor(self)
        
        // Get the current trait collection
        let currentTraitCollection = UIScreen.main.traitCollection
        // Resolve the color for the current trait collection
        let resolvedColor = uiColor.resolvedColor(with: currentTraitCollection)
        
        // Extract the RGB components from the resolved color
        guard let components = resolvedColor.cgColor.components, components.count >= 3 else {
            return 0.0 // Return a default value or handle the error
        }
        
        let r = components[0]
        let g = components[1]
        let b = components[2]
        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        // Calculating luminance
        let isDynamic = !resolvedColor.isEqual(uiColor)
        let isDarkMode = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        if isDynamic && isDarkMode {            
            return 1.0 - luminance
        } else {
            return luminance
        }
        
    }

    func contrastingTextColor() -> Color {
        return self.luminance() > 0.5 ? .black : .white
    }
    
    func isWhiteOrVeryLight() -> Bool {
        // Convert SwiftUI Color to UIColor and check if it is white or very light
        return UIColor(self).isWhiteOrVeryLight()
    }
    
    func adjustLightness(by amount: CGFloat) -> Color {
        // Convert SwiftUI Color to UIColor, adjust its lightness, and convert back
        return Color(UIColor(self).adjustLightness(by: amount))
    }
    
    func isLightColor() -> Bool {
        // Convert SwiftUI Color to UIColor and check if it is light
        return UIColor(self).isLightColor()
    }
}

extension UIColor {
    func isWhiteOrVeryLight() -> Bool {
        var white: CGFloat = 0
        var alpha: CGFloat = 0

        // Convert the color to white and alpha components
        getWhite(&white, alpha: &alpha)

        // Define a threshold for what you consider to be "very light"
        let threshold: CGFloat = 0.9 // This can be adjusted based on your needs

        return white > threshold
    }
    
    func adjustLightness(by amount: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        // Convert the UIColor to its HSB (Hue, Saturation, Brightness) components
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        // Adjust the brightness
        brightness += amount
        brightness = min(max(brightness, 0), 1) // Ensure brightness stays within the range 0-1

        // Return the color with adjusted brightness
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    func isLightColor() -> Bool {
        guard let components = cgColor.components, components.count >= 3 else {
            return false // Default to false if color can't be determined
        }

        // Calculate luminance
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue

        // A common threshold for determining if a color is light is 0.5
        return luminance > 0.5
    }
}

