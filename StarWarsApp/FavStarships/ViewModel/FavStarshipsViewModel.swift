//
//  FavStarshipsViewModel.swift
//  StarWarsApp
//
//  Created by Israa Assem on 01/08/2024.
//

import Foundation
protocol FavStarshipsViewModelProtocol{
    func getFavStarshipsArr()->[Starship]
    func getFavStarshipsArrCount()->Int
    func deleteFromFavStarships(starship:Starship)
    func retrieveStoredFavStarships()
    var bindFavStarshipsToViewController:()->Void{get set}
    func addStarshipToFav(starship:Starship)
}
final class FavStarshipsViewModel:FavStarshipsViewModelProtocol{
    private let favDao:FavStarWarsDao
    init(favDao:FavStarWarsDao){
        self.favDao=favDao
    }
    private var favStarshipsArr=[Starship]()
    func getFavStarshipsArr() -> [Starship] {
        favStarshipsArr
    }
    
    func getFavStarshipsArrCount() -> Int {
        favStarshipsArr.count
    }
    
    func deleteFromFavStarships(starship: Starship) {
        favDao.deleteStarship(starship: starship)
        retrieveStoredFavStarships()
    }
    
    func retrieveStoredFavStarships() {
        favStarshipsArr=favDao.retrieveStoredFavStarships()
        bindFavStarshipsToViewController()
    }
    
    var bindFavStarshipsToViewController: () -> Void={}
    
    func addStarshipToFav(starship: Starship) {
        var starships=[Starship]()
        starships.append(starship)
        favDao.saveFavStarshipsToCoreData(starshipsToStore: starships)
        retrieveStoredFavStarships()
    }
    
    
}
