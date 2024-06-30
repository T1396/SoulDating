//
//  Interest.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import Foundation


enum Interest: String, EditableItem, CaseIterable, Identifiable, Codable {
    case sports, reading, gaming, traveling, cooking, photography, music, movies, art, gardening, technology, fashion, fitness, politics, history, animals, volunteering, dancing, writing, meditation, astrology, birdwatching, hiking, diy, knitting
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .sports: "Sports"
        case .reading: "Reading"
        case .gaming: "Gaming"
        case .traveling: "Traveling"
        case .cooking: "Cooking"
        case .photography: "Photography"
        case .music: "Music"
        case .movies: "Movies"
        case .art: "Art"
        case .gardening: "Gardening"
        case .technology: "Technology"
        case .fashion: "Fashion"
        case .fitness: "Fitness"
        case .politics: "Politics"
        case .history: "History"
        case .animals: "Animals"
        case .volunteering: "Volunteering"
        case .dancing: "Dancing"
        case .writing: "Writing"
        case .meditation: "Meditation"
        case .astrology: "Astrology"
        case .birdwatching: "Birdwatching"
        case .hiking: "Hiking"
        case .diy: "Do It Yourself"
        case .knitting: "Knitting"
        }
    }

    var icon: String {
        switch self {
        case .sports: "sportscourt.fill"
        case .reading: "books.vertical.fill"
        case .gaming: "gamecontroller.fill"
        case .traveling: "airplane"
        case .cooking: "frying.pan.fill"
        case .photography: "camera.fill"
        case .music: "music.note.tv.fill"
        case .movies: "film.stack.fill"
        case .art: "theatermask.and.paintbrush.fill"
        case .gardening: "tree.fill"
        case .technology: "desktopcomputer"
        case .fashion: "tshirt.fill"
        case .fitness: "figure.walk"
        case .politics: "person.wave.2.fill"
        case .history: "text.book.closed.fill"
        case .animals: "pawprint.fill"
        case .volunteering: "hands.clap.fill"
        case .dancing: "figure.socialdance"
        case .writing: "pencil"
        case .meditation: "figure.yoga"
        case .astrology: "star"
        case .birdwatching: "binoculars"
        case .hiking: "map"
        case .diy: "hammer"
        case .knitting: "scissors"
        }
    }
}
