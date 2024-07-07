//
//  RadarFilter.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 23.06.24.
//

import Foundation

// wrapper struct for RadarFilter enum to return the title of the correlating enums
// and the rawValue to apply filters with it
struct FilterOption: Hashable {
    var title: String
    var rawValue: String
}

enum RadarFilter: Identifiable, CaseIterable {
    case education
    case interests
    case smoker
    case bodyType
    
    var id: String { title }
    
    var title: String {
        switch self {
        case .education: "Education"
        case .interests: "Interests"
        case .smoker: "Smoker"
        case .bodyType: "Body Type"
        }
    }
    
    var allOptions: [FilterOption] {
        switch self {
        case .education:
            return EducationLevel.allCases.map { FilterOption(title: $0.title, rawValue: $0.rawValue) }
        case .interests:
            return Interest.allCases.map { FilterOption(title: $0.title, rawValue: $0.rawValue) }
        case .smoker:
            return SmokeLevel.allCases.map { FilterOption(title: $0.title, rawValue: $0.rawValue) }
        case .bodyType:
            return BodyType.allCases.map { FilterOption(title: $0.title, rawValue: $0.rawValue) }
        }
    }
    
    
//    static let lessCases: [RadarFilter] = [
//        .education(EducationLevel.self),
//        .smoker(SmokeLevel.self),
//        .bodyType(BodyType.self)
//    ]
//    
//    static let allCases: [RadarFilter] = [
//        .education(EducationLevel.self),
//        .interests(Interest.self),
//        .smoker(SmokeLevel.self),
//        .bodyType(BodyType.self)
//    ]
//    
//    
//    static func == (lhs: RadarFilter, rhs: RadarFilter) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
}
