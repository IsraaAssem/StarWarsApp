//
//  Character.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import Foundation
struct CharactersResponse: Codable {
    let count: Int?
    let results: [Character]?
}

struct Character: Codable {
    let name, height: String?
    let skinColor, eyeColor, birthYear, gender: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case name, height
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender, url
    }
}
