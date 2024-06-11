//
//  RangeSlider.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct RangeSlider: View {
    @Binding var lowerBound: Double
    @Binding var upperBound: Double
    var range: ClosedRange<Double>
    var step: Double = 1.0
    
    // Slider-Geometrie
    @State private var width: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 5)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: width, height: 5)
                    .foregroundColor(.blue)
                    .offset(x: CGFloat((lowerBound - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width)
                
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
                    .offset(x: CGFloat((lowerBound - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                lowerBound = max(range.lowerBound, min(upperBound - step, convert(x: value.location.x, width: geometry.size.width)))
                            }
                    )
                
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.red)
                    .offset(x: CGFloat((upperBound - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                upperBound = min(range.upperBound, max(lowerBound + step, convert(x: value.location.x, width: geometry.size.width)))
                            }
                    )
            }
            .onAppear {
                width = CGFloat((upperBound - lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width
            }
        }
        .frame(height: 30)
    }
    
    func convert(x: CGFloat, width: CGFloat) -> Double {
        Double(x / width) * (range.upperBound - range.lowerBound) + range.lowerBound
    }
}
