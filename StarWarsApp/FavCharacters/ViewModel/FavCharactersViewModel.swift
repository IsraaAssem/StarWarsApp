//
//  FavCharactersViewModel.swift
//  StarWarsApp
//
//  Created by Israa Assem on 01/08/2024.
//

import Foundation
protocol FavCharactersViewModelProtocol{
    func getFavCharactersArr()->[Character]
    func getFavCharactersArrCount()->Int
    func deleteFromFavCharacters(character:Character)
    func retrieveStoredFavCharacters()
    var bindFavCharactersToViewController:()->Void{get set}
    func addCharacterToFav(character:Character)
}
final class FavCharactersViewModel:FavCharactersViewModelProtocol{
    private let favDao:FavStarWarsDao
    init(favDao:FavStarWarsDao){
        self.favDao=favDao
    }
    private var favCharactersArr=[Character]()
    func getFavCharactersArr() -> [Character] {
        favCharactersArr
    }
    
    func getFavCharactersArrCount() -> Int {
        favCharactersArr.count
    }
    
    func deleteFromFavCharacters(character: Character) {
        favDao.deleteCharacter(character: character)
        retrieveStoredFavCharacters()
    }
    
    func retrieveStoredFavCharacters() {
        favCharactersArr=favDao.retrieveStoredFavCharacters()
        bindFavCharactersToViewController()
    }
    
    var bindFavCharactersToViewController: () -> Void={}
    
    func addCharacterToFav(character: Character) {
        var characters=[Character]()
        characters.append(character)
        favDao.saveFavCharactersToCoreData(charactersToStore: characters)
        retrieveStoredFavCharacters()
    }
    
    
}
