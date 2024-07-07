//
//  AppFont.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 15.06.24.
//

import Foundation
import SwiftUI

struct AppFont: ViewModifier {
    let size: CGFloat
    var textWeight: TextWeight
    func body(content: Content) -> some View {
        content
            .font(.custom(textWeight.identifier, size: size))
    }
}

extension View {
    func appFont(size: CGFloat = 18, textWeight: AppFont.TextWeight = .regular) -> some View {
        self.modifier(AppFont(size: size, textWeight: textWeight))
    }
}



extension AppFont {
    enum TextWeight: String {
        case black, blackItalic, bold, bolditalic, extrabold, extrabolditalic, extralight, extralightitalic, italic, light, lightitalic, medium, mediumitalic, regular, semibold, semibolditalic, thin, thinitalic
        
        var identifier: String {
            switch self {
            case .black: "Montserrat-Black"
            case .blackItalic: "Montserrat-BlackItalic"
            case .bold: "Montserrat-Bold"
            case .bolditalic: "Montserrat-BoldItalic"
            case .extrabold: "Montserrat-ExtraBold"
            case .extrabolditalic: "Montserrat-ExtraBoldItalic"
            case .extralight: "Montserrat-ExtraLight"
            case .extralightitalic: "Montserrat-ExtraLightItalic"
            case .italic: "Montserrat-Italic"
            case .light: "Montserrat-Light"
            case .lightitalic: "Montserrat-LightItalic"
            case .medium: "Montserrat-Medium"
            case .mediumitalic: "Montserrat-MediumItalic"
            case .regular: "Montserrat-Regular"
            case .semibold: "Montserrat-SemiBold"
            case .semibolditalic: "Montserrat-SemiBoldItalic"
            case .thin: "Montserrat-Thin"
            case .thinitalic: "Montserrat-ThinItalic"
            }
        }
    }
}
