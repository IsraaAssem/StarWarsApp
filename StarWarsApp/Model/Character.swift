//
//  Character.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import Foundation
struct CharactersResponse: Codable {
    let count: Int?
    let next: String?
    let results: [Character]?
}

struct Character: Codable {
    let name, height, mass, hairColor: String?
    let skinColor, eyeColor, birthYear, gender: String?
    let homeworld: String?
    let films: [String]?
    let vehicles, starships: [String]?
    let created, edited: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender, homeworld, films,vehicles, starships, created, edited, url
    }
}
