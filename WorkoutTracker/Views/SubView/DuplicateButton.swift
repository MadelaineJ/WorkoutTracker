//
//  DuplicateButton.swift
//  LiftTracker
//
//  Created by Madelaine Jones on 2024-02-03.
//

import SwiftUI

struct DuplicateButton: View {
    var body: some View {
        ZStack {
            
        Circle()
            .frame(width: 45, height: 45)
            .foregroundColor(Color(.systemIndigo))
            .padding()
        
        Image(systemName: "doc.on.doc.fill")
            .foregroundColor(.white)
            .font(.system(size: 22))

        }
        .accessibilityLabel("Duplicate")
    }
}

#Preview {
    DuplicateButton()
}
