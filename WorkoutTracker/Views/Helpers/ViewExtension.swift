//
//  ViewExtension.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-10-20.
//

import SwiftUI

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
