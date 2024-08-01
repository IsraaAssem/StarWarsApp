//
//  Starship.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import Foundation

struct StarshipResponse: Codable {
    let count: Int?
    let results: [Starship]?
}

struct Starship: Codable {
    let name, model, manufacturer, costInCredits: String?
    let crew, passengers: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case name, model, manufacturer
        case costInCredits = "cost_in_credits"
        case crew, passengers,  url
    }
}
