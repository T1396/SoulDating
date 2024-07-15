//
//  EducationLevel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 15.06.24.
//

import Foundation

// swiftlint:disable inclusive_language
enum EducationLevel: String, EditableItem, CaseIterable, Identifiable, Codable {
    case none, highSchool, someCollege, associate, bachelor, master, doctoral, professional
    
    var id: String { rawValue }
    var title: String {
        switch self {
        case .none: Strings.none
        case .highSchool: Strings.highSchool
        case .someCollege: Strings.someCollege
        case .associate: Strings.associateDegree
        case .bachelor: Strings.bachelor
        case .master: Strings.masterDegree
        case .doctoral: Strings.doctoralDegree
        case .professional: Strings.professionalDegree
        }
    }

    var icon: String {
        switch self {
        case .none: "xmark.circle"
        case .highSchool: "book.closed.fill"
        case .someCollege: "books.vertical.fill"
        case .associate: "person.fill.checkmark"
        case .bachelor: "graduationcap.fill"
        case .master: "graduationcap"
        case .doctoral: "doc.text.fill"
        case .professional: "briefcase.fill"
        }
    }
    
    static var generalIcon: String {
        "graduationcap.fill"
    }
}
