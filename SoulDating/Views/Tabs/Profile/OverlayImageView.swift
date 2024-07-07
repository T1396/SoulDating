//
//  OverlayImageView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 23.06.24.
//

import SwiftUI

struct OverlayImageView: View {
    @Binding var isImagePresented: Bool
    @Binding var loadedImage: Image?
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .zIndex(1)
            .onTapGesture {
                hideOverlay()
            }
        
        VStack {
            Button(action: hideOverlay) {
                if let loadedImage {
                    loadedImage
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(.thickMaterial)
                        )
                        .frame(width: width, height: height)
                    
                } else {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 80))
                        .frame(width: width, height: height)
                        .padding(4)
                        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                }
            }
            .zIndex(2)
            
            Button(action: {

            }, label: {
                Text("Update picture")
                    .appFont(size: 14, textWeight: .bold)
                    .padding()
                    .frame(width: width)
                    .background(.cyan, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .foregroundStyle(.white)
            })
        }
        .ignoresSafeArea(.all)
        .zIndex(3)
        .shadow(radius: 10)
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
        .frame(width: width, alignment: .center)
    }
    
    private func hideOverlay() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isImagePresented.toggle()
        }
    }
}

#Preview {
    OverlayImageView(isImagePresented: .constant(true), loadedImage: .constant(nil), width: 100, height: 200)
}
