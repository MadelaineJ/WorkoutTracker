//
//  Tooltip.swift
//  WorkoutTracker
//
//  Created by Madelaine Jones on 2023-12-01.
//

import SwiftUI

import SwiftUI

struct Tooltip: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(8)
            .foregroundColor(.white)
            .background(Color.black.opacity(0.75))
            .cornerRadius(10)
            .overlay(
                Triangle()
                    .fill(Color.black.opacity(0.75))
                    .frame(width: 10, height: 10)
                    .rotationEffect(Angle(degrees: 45)), alignment: .bottom
            )
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLines([
            CGPoint(x: rect.minX, y: rect.maxY),
            CGPoint(x: rect.maxX, y: rect.maxY),
            CGPoint(x: rect.midX, y: rect.minY)
        ])
        path.closeSubpath()
        return path
    }
}


#Preview {
    Tooltip(text: "Start your workout Here!")
}
