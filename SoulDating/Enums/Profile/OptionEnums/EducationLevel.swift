//
//  EducationLevel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 15.06.24.
//

import Foundation

import Foundation

enum EducationLevel: String, EditableItem, CaseIterable, Identifiable, Codable {
    case none, highSchool, someCollege, associate, bachelor, master, doctoral, professional
    
    var id: String { rawValue }
    var title: String {
        switch self {
        case .none: "None"
        case .highSchool: "High School"
        case .someCollege: "Some College"
        case .associate: "Associate Degree"
        case .bachelor: "Bachelors Degree"
        case .master: "Master's Defree"
        case .doctoral: "Doctoral Degree"
        case .professional: "Professional Degree"
        }
    }
    
    var description: String {
        switch self {
        case .none:
            return "No formal education"
        case .highSchool:
            return "Graduated high school or equivalent"
        case .someCollege:
            return "Attended college but did not graduate"
        case .associate:
            return "Completed an associate degree"
        case .bachelor:
            return "Completed a bachelor's degree"
        case .master:
            return "Completed a master's degree"
        case .doctoral:
            return "Completed a doctoral degree"
        case .professional:
            return "Completed a professional degree (e.g., MD, JD)"
        }
    }
    
    var icon: String {
        switch self {
        case .none:
            return "xmark.circle"
        case .highSchool:
            return "book.closed.fill"
        case .someCollege:
            return "books.vertical.fill"
        case .associate:
            return "person.fill.checkmark"
        case .bachelor:
            return "graduationcap.fill"
        case .master:
            return "graduationcap"
        case .doctoral:
            return "doc.text.fill"
        case .professional:
            return "briefcase.fill"
        }
    }
    
    var generalIcon: String {
        "graduationcap.fill"
    }
}
