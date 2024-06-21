//
//  ProfileItem.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 10.06.24.
//

import Foundation
import Firebase

enum ProfileItem: Identifiable, Equatable {
    case name(String)
    case birthdate(Date)
    case gender(Gender)
    case preferredGender(Gender)
    case job(String?)
    case description(String?)
    case languages([String])
    case height(Int?)
    case smokingStatus(SmokeLevel?)
    case education(EducationLevel?)
    case location(LocationPreference)
    case interests([Interest])
    case ageRangePreference(AgePreference?)
    case heightPreference(Int?)
    case smokingPreference(SmokeLevel?)
    
    var id: String { title }
    
    var title: String {
        switch self {
        case .name: "Name"
        case .birthdate: "Birthdate"
        case .location: "Location"
        case .job: "Job"
        case .description: "Description"
        case .languages: "Languages"
        case .gender: "Your gender"
        case .preferredGender: "Your preferred gender"
        case .interests: "Your interests"
        case .height: "Your height"
        case .smokingStatus: "Do you smoke?"
        case .education: "Education level"
        case .ageRangePreference: "Preferred Ages"
        case .heightPreference: "Preferred height"
        case .smokingPreference: "Only looking for non smokers?"
        }
    }
    

    
    var value: String {
        switch self {
        case .name(let name): return name
        case .birthdate(let date): return date.toDateString()
        case .location(let location): return location.name
        case .job(let job): return job ?? "Not specified"
        case .description(let description): return description ?? "No description written"
        case .languages(let languages): return languages.seperated(emptyText: "No languages added")
        case .gender(let gender): return gender.title
        case .preferredGender(let gender): return gender.title
        case .interests(let interests): return interests.dropFirst(3).map { $0.title }.seperated(emptyText: "No interests added")
        case .height(let height): return height != nil ? String(height ?? 174) : "No height specified"
        case .smokingStatus(let smokingStatus): return smokingStatus?.description ?? "Not specified"
        case .education(let education): return education?.title ?? "Not specified"
        case .ageRangePreference(let agePref):
            if let minAge = agePref?.minAge, let maxAge = agePref?.maxAge {
                return "\(Int(minAge)) - \(Int(maxAge))"
            } else {
                return "No age range specified"
            }
        case .heightPreference(let heightPref): return heightPref != nil ? String(heightPref ?? 180) : "Not specified"
        case .smokingPreference(let smokingPref): return smokingPref?.description ?? "Not specified"
        }
    }
    
    var editText: String {
        switch self {
        case .name(_): "Update your username"
        case .birthdate: "Update your birthdate"
        case .location: "Update your location"
        case .job: "Update your actual Job"
        case .description: "Update your description"
        case .languages: "Update your spoken languages"
        case .gender: "Update your gender"
        case .preferredGender: "Update your preferred gender(s)"
        case .interests: "Update your interests"
        case .height: "Update your height"
        case .smokingStatus: "Update your smoking status"
        case .education: "Update your educational level"
        case .ageRangePreference: "Update your preferred ages"
        case .heightPreference: "Update your preferred height"
        case .smokingPreference: "Update your smoking preferences"
        }
    }
    
    var icon: String {
        switch self {
        case .name: "person.fill"
        case .birthdate: "calendar"
        case .gender, .preferredGender: "person.crop.circle"
        case .job: "briefcase.fill"
        case .description: "text.quote"
        case .languages: "character.book.closed.fill"
        case .height: "arrow.up.and.down.circle.fill"
        case .smokingStatus, .smokingPreference: "smoke.fill"
        case .education: "graduationcap.fill"
        case .location: "map.fill"
        case .interests: "heart.text.square.fill"
        case .ageRangePreference: "slider.horizontal.3"
        case .heightPreference: "ruler.fill"
        }
    }
    
    
    var supportText: String? {
        switch self {
        case .birthdate: return "This will update your user suggestions"
        case .gender: return "This will change who you are suggested to"
        case .preferredGender: return "This will change your user suggestions"
        default:
            return nil
        }
    }
}
