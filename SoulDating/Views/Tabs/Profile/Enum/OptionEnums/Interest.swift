//
//  Interest.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import Foundation


enum Interest: String, EditableItem, CaseIterable, Identifiable, Codable {
    case animals, art, astrology, birdwatching, cooking, dancing, diy, fashion, fitness, gaming, gardening, hiking, history, knitting, meditation, music, movies, photography, politics, reading, sports, traveling, technology, volunteering, writing

    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .animals: Strings.animals
        case .art: Strings.art
        case .astrology: Strings.astrology
        case .birdwatching: Strings.birdwatching
        case .cooking: Strings.cooking
        case .dancing: Strings.dancing
        case .diy: Strings.diy
        case .fashion: Strings.fashion
        case .fitness: Strings.fitness
        case .gaming: Strings.gaming
        case .gardening: Strings.gardening
        case .hiking: Strings.hiking
        case .history: Strings.history
        case .knitting: Strings.knitting
        case .meditation: Strings.meditation
        case .music: Strings.music
        case .movies: Strings.movies
        case .photography: Strings.photography
        case .politics: Strings.politics
        case .reading: Strings.reading
        case .sports: Strings.sports
        case .traveling: Strings.traveling
        case .technology: Strings.technology
        case .volunteering: Strings.volunteering
        case .writing: Strings.writing

        }
    }

    var icon: String {
        switch self {
        case .animals: "pawprint.fill"
        case .art: "theatermask.and.paintbrush.fill"
        case .astrology: "star"
        case .birdwatching: "binoculars"
        case .cooking: "frying.pan.fill"
        case .dancing: "figure.socialdance"
        case .diy: "hammer"
        case .fashion: "tshirt.fill"
        case .fitness: "figure.walk"
        case .gaming: "gamecontroller.fill"
        case .gardening: "tree.fill"
        case .hiking: "map"
        case .history: "text.book.closed.fill"
        case .knitting: "scissors"
        case .meditation: "figure.yoga"
        case .music: "music.note.tv.fill"
        case .movies: "film.stack.fill"
        case .photography: "camera.fill"
        case .politics: "person.wave.2.fill"
        case .reading: "books.vertical.fill"
        case .sports: "sportscourt.fill"
        case .traveling: "airplane"
        case .technology: "desktopcomputer"
        case .volunteering: "hands.clap.fill"
        case .writing: "pencil"
        }
    }
}
