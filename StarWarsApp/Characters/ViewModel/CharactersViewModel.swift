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
    var updateTable:()->Void{get set}
    func fetchCharacters()->Void
    func filterCharacters(by searchText:String)->Void
}
final class CharactersViewModel:CharactersViewModelProtocol{
    private var allCharacters=[Character]()
    private var filteredCharacters=[Character]()
    private let networkService:NetworkServiceProtocol?
    var updateTable: () -> Void={}
    init(networkService:NetworkServiceProtocol){
        self.networkService=networkService
    }
    func getCharactersArr() -> [Character] {
        filteredCharacters
    }
    
    func getCharactersCount() -> Int {
        filteredCharacters.count
    }
    
    var bindCharactersToViewController: () -> Void={}
    
    func fetchCharacters(){
        networkService?.fetchData(from: "people/", completion: { [weak self](result:Result<CharactersResponse,NetworkError>) in
            switch result{
                case .success(let data):
                    self?.bindCharactersToViewController()
                    self?.allCharacters=data.results ?? []
                    self?.filteredCharacters=self?.allCharacters ?? []
                case .failure(let error):
                    print(error)
            }
        })
    }
    func filterCharacters(by searchText:String)->Void{
        if searchText.isEmpty{
            filteredCharacters=allCharacters
        }else{
            networkService?.fetchData(from: "people/?search=\(searchText)", completion: { [weak self](result:Result<CharactersResponse,NetworkError>) in
                switch result{
                    case .success(let data):
                        self?.bindCharactersToViewController()
                        self?.filteredCharacters=data.results ?? []
                    case .failure(let error):
                        print(error)
                }
            })
        }
        updateTable()
    }
}
