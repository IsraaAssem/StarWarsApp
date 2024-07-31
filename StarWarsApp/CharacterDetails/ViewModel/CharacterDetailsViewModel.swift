//
//  CharacterDetailsViewModel.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import Foundation
protocol CharacterDetailsViewModelProtocol{
    func getCharacter()->Character?
}
final class CharacterDetailsViewModel:CharacterDetailsViewModelProtocol{
    private var character:Character?
    init(character: Character?) {
        self.character = character ?? nil
    }
    func getCharacter() -> Character? {
        character
    }
    
}
