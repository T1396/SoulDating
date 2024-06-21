//
//  RangeSliderView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import SwiftUI

extension AgeRangeSliderView {
    // Initializer with binding values
    init(userLowerbound: Binding<Double>, userUpperbount: Binding<Double>, minValue: CGFloat = 17, maxValue: CGFloat = 100) {
        self._userLowerbound = userLowerbound
        self._userUpperbound = userUpperbount
        self.minValue = minValue
        self.maxValue = maxValue
    }
    // Initializer for Double values
    init(userLowerbound: Double, userUpperbound: Double, minValue: CGFloat = 17, maxValue: CGFloat = 100) {
        self._userLowerbound = .constant(userLowerbound)
        self._userUpperbound = .constant(userUpperbound)
        self.minValue = minValue
        self.maxValue = maxValue
    }
}

struct AgeRangeSliderView: View {
    // MARK: properties
    @Binding var userLowerbound: Double
    @Binding var userUpperbound: Double
    
    @State private var firstSliderPos: CGFloat = 0
    @State private var secondSliderPos: CGFloat = 15
    @State private var totalScreen: CGFloat = 0
    @State private var isDraggingLeft = false
    @State private var isDraggingRight = false
    
    let offsetValue: CGFloat = 40
    var maxValue: CGFloat = 100
    var minValue: CGFloat = 17
    
    // MARK: computed properties
    var lowerValue: Int {
        Int(positionToValue(value: firstSliderPos, from: 0...totalScreen, to: minValue...maxValue))
    }
    var upperValue: Int {
        Int(positionToValue(value: secondSliderPos, from: 0...totalScreen, to: minValue...maxValue))
    }
    
    // MARK: body
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                Text("Choose your preferred age range")
                    .appFont(size: 16, textWeight: .medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.primary)
                Text("Current: \(Int(lowerValue)) - \(Int(upperValue))")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appFont(size: 14)
                    .padding(.top, 4)
                
                ZStack(alignment: .leading) {
                    backgroundBar
                    progressBar
                    HStack(spacing: 0) {
                        sliderHandle(isLeft: true)
                        sliderHandle(isLeft: false)
                    }
                    ValueBox(isDragging: isDraggingLeft, value: Int(lowerValue), position: firstSliderPos, xOffset: -15)
                    ValueBox(isDragging: isDraggingRight, value: Int(upperValue), position: secondSliderPos, xOffset: 5)
                }
                .offset(y: 8)
            }
            .frame(width: geometry.size.width, height: 130)
            .onAppear {
                DispatchQueue.main.async {
                    totalScreen = max((geometry.size.width - offsetValue), 0)
                    print(totalScreen)
                    print(userLowerbound)
                    print(userUpperbound)
                    firstSliderPos = valueToPosition(value: userLowerbound, minValue: minValue, maxValue: maxValue, totalScreen: totalScreen)
                    secondSliderPos = valueToPosition(value: userUpperbound, minValue: minValue, maxValue: maxValue, totalScreen: totalScreen)
                    print(firstSliderPos)
                    print(secondSliderPos)
                }
            }
            
        }
        .frame(height: 130)
        .padding(.horizontal)
        .itemBackgroundStyle()
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 0)
//        .onChange(of: firstSliderPos) { oldValue, newValue in
//            userLowerbound = Double(positionToValue(value: newValue, from: 0...totalScreen, to: minValue...maxValue).rounded())
//            print(userLowerbound)
//        }
//        .onChange(of: secondSliderPos) { oldValue, newValue in
//            userUpperbound = Double(positionToValue(value: newValue, from: 0...totalScreen, to: minValue...maxValue).rounded())
//            print(userUpperbound)
//        }
    }
    // MARK: view properties
    var backgroundBar: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.gray.opacity(0.3))
            .frame(height: 6)
            .padding(.horizontal, 6)
    }
    
    var progressBar: some View {
        Rectangle()
            .foregroundStyle(.blue.opacity(0.4))
            .frame(width: secondSliderPos - firstSliderPos, height: 6)
            .offset(x: firstSliderPos + 20)
    }
    
    @ViewBuilder
    private func sliderHandle(isLeft: Bool) -> some View {
        DraggableCircle(
            circlePosition: isLeft ? .left : .right,
            limit: totalScreen,
            minValue: minValue,
            maxValue: maxValue,
            isDragging: isLeft ? $isDraggingLeft : $isDraggingRight,
            position: isLeft ? $firstSliderPos : $secondSliderPos,
            otherPosition: isLeft ? $secondSliderPos : $firstSliderPos

        ) { newValue in
            if isLeft {
                userLowerbound = newValue.rounded(.down)
                print("New lowerbound: \(userLowerbound)")
            } else {
                userUpperbound = newValue.rounded(.down)
                print("New upperBound: \(userUpperbound)")
            }
        }
    }
}

struct DraggableCircle: View {
    // MARK: properties
    enum CirclePosition { case left, right }
    var circlePosition: CirclePosition
    var limit: CGFloat
    var minValue: CGFloat
    var maxValue: CGFloat
    // callback with the updated value, returned when slide is ended
    
    @Binding var isDragging: Bool
    @Binding var position: CGFloat
    @Binding var otherPosition: CGFloat
    
    var onDragEnd: (Double) -> Void

    
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
        .offset(x: position + (circlePosition == .left ? 0 : -5))
        .gesture(
            DragGesture()
                .onChanged({ value in
                    withAnimation {
                        isDragging = true
                    }
                    if circlePosition == .left {
                        position = min(max(value.location.x, 0), otherPosition)
                    } else {
                        position = min(max(value.location.x, otherPosition), limit)
                    }
                })
                .onEnded({ value in
                    withAnimation {
                        isDragging = false
                        onDragEnd(positionToValue(value: position, from: 0...limit, to: minValue...maxValue))
                    }
                })
        )
    }
    
    
}

/// convert position to values and values to sliderposition coordinates
extension View {
    func positionToValue(value: CGFloat, from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
            let inputRange = from.upperBound - from.lowerBound
            guard inputRange != 0 else { return 0 }
            let outputRange = to.upperBound - to.lowerBound
            return (value - from.lowerBound) / inputRange * outputRange + to.lowerBound
        }
    
    func valueToPosition(value: Double, minValue: Double, maxValue: Double, totalScreen: Double) -> CGFloat {
        let scaledValue = CGFloat((value - minValue) / (maxValue - minValue))
        return scaledValue * (totalScreen)
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
    AgeRangeSliderView(userLowerbound: .constant(18), userUpperbound: .constant(92))
}
