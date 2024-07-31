//
//  CharacterDetailsViewModel.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import Foundation
protocol CharacterDetailsViewModelProtocol{
    func getCharacter()->Character?
    func getStarship()->Starship?
    func getItemType()->String
}
final class CharacterDetailsViewModel:CharacterDetailsViewModelProtocol{
    private var character:Character?
    private var starship:Starship?
    private var itemType:String
    init(character: Character?,starship:Starship?,itemType:String) {
        self.character = character ?? nil
        self.starship=starship ?? nil
        self.itemType=itemType
    }
    func getCharacter() -> Character? {
        character
    }
    func getStarship()->Starship?{
        starship
    }
    func getItemType()->String{
        itemType
    }
}
