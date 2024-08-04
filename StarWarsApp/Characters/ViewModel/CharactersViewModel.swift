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
    func fetchCharacters(pageNumber:Int)->Void
    func filterCharacters(by searchText:String)->Void
    func setCurrentPage(pageNum:Int)->Void
    func getCurrentPage()->Int
    var showNetworkError:()->Void{get set}
}
final class CharactersViewModel:CharactersViewModelProtocol{
    private var allCharacters=[Character]()
    private var filteredCharacters=[Character]()
    private let networkService:NetworkServiceProtocol?
    private var currentPage=1
    var updateTable: () -> Void={}
    var showNetworkError: () -> Void
    init(networkService:NetworkServiceProtocol, showNetworkError: @escaping()->Void ){
        self.networkService=networkService
        self.showNetworkError=showNetworkError
    }
    func getCharactersArr() -> [Character] {
        filteredCharacters
    }
    
    func getCharactersCount() -> Int {
        filteredCharacters.count
    }
    
    var bindCharactersToViewController: () -> Void={}
    
    func fetchCharacters(pageNumber:Int){
        networkService?.fetchData(from: "people/?page=\(pageNumber)", completion: { [weak self](result:Result<CharactersResponse,NetworkError>) in
            switch result{
                case .success(let data):
                    self?.filteredCharacters=self?.allCharacters ?? []
                    self?.allCharacters.append( contentsOf: data.results ?? [] )
                    self?.currentPage=pageNumber
                    self?.bindCharactersToViewController()
                case .failure(let error):
                    print("Error: \(error)")
                    self?.showNetworkError()
            }
        })
        print("Page num: \(pageNumber)")
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
                        print("Error: \(error)")
                        self?.showNetworkError()
                }
            })
        }
        updateTable()
    }
    func setCurrentPage(pageNum:Int)->Void{
        currentPage=pageNum
    }
    func getCurrentPage()->Int{
        currentPage
    }
}
