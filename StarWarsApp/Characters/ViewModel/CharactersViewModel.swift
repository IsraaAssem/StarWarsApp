//
//  CharactersView.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import Foundation
protocol CharactersViewModelProtocol{
    func getCharactersArr()->[Character]
    func getCharactersCount()->Int
    var bindCharactersToViewController:()->Void{get set}
    func fetchCharacters()->Void
}
final class CharactersViewModel:CharactersViewModelProtocol{
    private var charactersArr=[Character]()
    private let networkService:NetworkServiceProtocol?
    init(networkService:NetworkServiceProtocol){
        self.networkService=networkService
    }
    func getCharactersArr() -> [Character] {
        charactersArr
    }
    
    func getCharactersCount() -> Int {
        charactersArr.count
    }
    
    var bindCharactersToViewController: () -> Void={}
    
    func fetchCharacters(){
        networkService?.fetchData(from: "people/", completion: { [weak self](result:Result<CharactersResponse,NetworkError>) in
            switch result{
                case .success(let data):
                    self?.bindCharactersToViewController()
                    self?.charactersArr=data.results ?? []
                case .failure(let error):
                    print(error)
            }
        })
    }
}
