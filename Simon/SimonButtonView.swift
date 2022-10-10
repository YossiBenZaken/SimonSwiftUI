//
//  SimonButtonView.swift
//  Simon
//
//  Created by Yosef Ben Zaken on 10/10/2022.
//

import SwiftUI

struct SimonButtonView: View {
    let slice: Slice
    let color: Color
    let center: CGPoint
    let radius: Double
    var body: some View {
        Path { path in
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: slice.start, endAngle: slice.end, clockwise: false)
        }
        .fill(color)
    }
}

struct SimonButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {reader in
            let halfWidth = (reader.size.width / 2)
                let halfHeight = (reader.size.height / 2)
                let radius = min(halfWidth, halfHeight)
                let center = CGPoint(x: halfWidth, y: halfHeight)
            SimonButtonView(slice: Slice(start: Angle(degrees: 90), end: Angle(degrees: 180)),color: .red, center: center, radius: radius)
        }
    }
}
