//
//  CustomSheetBehaviour.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import SwiftUI

struct SheetBehavior: ViewModifier {
    @Binding var isPresented: Bool
    let minHeight: CGFloat
    
    @State private var offset = CGSize.zero
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                if isPresented {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isPresented = false
                            }
                        }
                    content
                        .frame(width: geometry.size.width, height: geometry.size.height - offset.height, alignment: .top)
                        .background(Color.white)
                        .cornerRadius(20)
                        .offset(y: offset.height > 0 ? offset.height : 0)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if gesture.translation.height > 0 {
                                        offset = gesture.translation
                                    }
                                }
                                .onEnded { _ in
                                    if offset.height > 150 {
                                        withAnimation {
                                            isPresented = false
                                        }
                                    }
                                    offset = .zero
                                }
                        )
                }
            }
        }
    }
}

extension View {
    func sheetBehavior(isPresented: Binding<Bool>, minHeight: CGFloat) -> some View {
        self.modifier(SheetBehavior(isPresented: isPresented, minHeight: minHeight))
    }
}
