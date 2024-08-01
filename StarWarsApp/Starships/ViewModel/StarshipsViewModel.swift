//
//  StarshipsViewModel.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import Foundation
import Combine
protocol StarshipsViewModelProtocol{
    func fetchStarships()->Void
    func getStarships()->[Starship]
    func getStarshipsCount()->Int
    var bindStarshipsToViewController:()->Void{get set}
    var updateTable:()->Void{get set}
    func filterStarships(by searchText:String)->Void
}
final class StarshipsViewModel:StarshipsViewModelProtocol{
    private var starships=[Starship]()
    private var filteredStarships=[Starship]()
    private let networkService:NetworkServiceProtocol
    init(networkService:NetworkServiceProtocol) {
        self.networkService=networkService
    }
    var bindStarshipsToViewController: () -> Void={}
    var updateTable: () -> Void={}
    func fetchStarships() {
        networkService.fetchData(from: "starships/") {[weak self] (result:Result<StarshipResponse,NetworkError>) in
            switch result{
                case .failure(let error):
                    print(error)
                case .success(let data):
                    self?.starships=data.results ?? []
                    self?.filteredStarships=self?.starships ?? []
                    self?.bindStarshipsToViewController()
            }
        }
    }
    
    func getStarships()->[Starship] {
        return filteredStarships
    }
    
    func getStarshipsCount() -> Int {
        return filteredStarships.count
    }
    func filterStarships(by searchText:String)->Void{
        if searchText.isEmpty{
            filteredStarships=starships
        }else{
            filteredStarships=starships.filter{
                $0.name?.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
        updateTable()
    }
}
