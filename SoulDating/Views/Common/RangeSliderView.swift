//
//  RangeSliderView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

struct RangeSliderView: View {
    @Binding var userLowerbound: Double
    @Binding var userUpperbound: Double
    
    @State private var width: CGFloat = 0
    @State private var widthTow: CGFloat = 15
    @State private var totalScreen: CGFloat = 0
    @State private var isDraggingLeft = false
    @State private var isDraggingRight = false
    
    let offsetValue: CGFloat = 40
    let maxValue: CGFloat = 100
    let minValue: CGFloat = 18

    var lowerValue: Int {
        Int(map(value: width, from: 0...totalScreen, to: minValue...maxValue))
    }
    var upperValue: Int {
        Int(map(value: widthTow, from: 0...totalScreen, to: minValue...maxValue))
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack() {
                Text("Wähle deinen bevorzugten Altersbereich")
                Text("Aktuell: \(Int(lowerValue)) - \(Int(upperValue))")
                    .font(.subheadline)
                    .padding(.top, 8)
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.gray)
                        .opacity(0.3)
                        .frame(height: 6)
                        .padding(.horizontal, 6)
                    
                    Rectangle().foregroundStyle(.blue.opacity(0.4))
                        .frame(width: widthTow - width, height: 6)
                        .offset(x: width + 20)
                    
                    HStack(spacing: 0) {
                        DraggableCircle(isLeft: true, isDragging: $isDraggingLeft, position: $width, otherPosition: $widthTow, limit: totalScreen)
                        DraggableCircle(isLeft: false, isDragging: $isDraggingRight, position: $widthTow, otherPosition: $width, limit: totalScreen)
                    }
                    
                    ValueBox(isDragging: isDraggingLeft, value: Int(lowerValue), position: width, xOffset: -15)
                    ValueBox(isDragging: isDraggingRight, value: Int(upperValue), position: widthTow, xOffset: 5)
                }
                .offset(y: 8)
            }
            .frame(width: geometry.size.width, height: 130)
            .onAppear {
                totalScreen = geometry.size.width - offsetValue
                width = map(value: CGFloat(userLowerbound), from: 0...totalScreen, to: minValue...maxValue)
                widthTow = map(value: CGFloat(userUpperbound), from: 0...totalScreen, to: minValue...maxValue)
                print("Userlower: \(userLowerbound)")
                print("Userupper: \(userUpperbound)")
                print("Width: \(width)")
                print("WidthTow: \(widthTow)")
            }
            
        }
        .frame(height: 130)
        .padding(.horizontal)
        .itemBackgroundStyle()
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 0)
    }
    
    private func map(value: CGFloat, from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        let inputRange = from.upperBound - from.lowerBound
        guard inputRange != 0 else { return 0 }
        let outputRange = to.upperBound - to.lowerBound
        return (value - from.lowerBound) / inputRange * outputRange + to.lowerBound
    }
}

struct DraggableCircle: View {
    var isLeft: Bool
    @Binding var isDragging: Bool
    @Binding var position: CGFloat
    @Binding var otherPosition: CGFloat
    var limit: CGFloat
    
    var size: (height: CGFloat, width: CGFloat) {
        isDragging ? (height: 30, width: 30) : (height: 25, width: 25)
    }
    
    var innerSize: (height: CGFloat, width: CGFloat) {
        isDragging ? (height: 20, width: 20) : (height: 15, width: 15)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: size.width, height: size.height)
                .foregroundStyle(.blue)
            Circle()
                .frame(width: innerSize.width, height: innerSize.height)
                .foregroundStyle(.white)
        }
        .offset(x: position + (isLeft ? 0 : -5))
        .gesture(
            DragGesture()
                .onChanged({ value in
                    withAnimation {
                        isDragging = true
                    }
                    if isLeft {
                        position = min(max(value.location.x, 0), otherPosition)
                    } else {
                        position = min(max(value.location.x, otherPosition), limit)
                    }
                })
                .onEnded({ value in
                    withAnimation {
                        isDragging = false
                    }
                })
        )
    }
}

struct ValueBox: View {
    var isDragging: Bool
    var value: Int
    var position: CGFloat
    var xOffset : CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .frame(width: 60, height: 40)
                .foregroundStyle(isDragging ? .black : .clear)
            Text("\(value)")
                .foregroundStyle(isDragging ? .white : .clear)
        }
        .scaleEffect(isDragging ? 1 : 0)
        .offset(x: position + xOffset, y: isDragging ? -40 : 0)
    }
}

#Preview {
    RangeSliderView(userLowerbound: .constant(0), userUpperbound: .constant(50))
}
