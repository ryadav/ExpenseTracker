//
//  PieChartView.swift
//  ExpenseTracker
//
//  Created by Apple on 06/11/24.
//

import SwiftUI

struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(center: center, radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}


struct PieChartView: View {
    let data: [(value: Int, color: Color, label: String)]
    
    var total: Double {
        Double(data.map { $0.value }.reduce(0, +))
    }
    
    var angleData: [(startAngle: Angle, endAngle: Angle, color: Color, label: String)] {
        var currentAngle: Double = 0
        return data.map { item in
            let startAngle = Angle.degrees(currentAngle)
            currentAngle += Double(item.value) / total * 360
            let endAngle = Angle.degrees(currentAngle)
            return (startAngle: startAngle, endAngle: endAngle, color: item.color, label: item.label)
        }
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<angleData.count, id: \.self) { index in
                let slice = angleData[index]
                
                // Draw the slice
                PieSlice(startAngle: slice.startAngle, endAngle: slice.endAngle)
                    .fill(slice.color)
                
                // Calculate label position
                let midAngle = Angle.degrees((slice.startAngle.degrees + slice.endAngle.degrees) / 2)
                let labelX = 150 + cos(midAngle.radians) * 100
                let labelY = 150 + sin(midAngle.radians) * 100
                
                // Add the label
                Text(slice.label)
                    .position(x: labelX, y: labelY)
                    .foregroundColor(.white)
                    .font(.caption)
            }
        }
        .frame(width: 300, height: 300)
        .padding()
    }
}
