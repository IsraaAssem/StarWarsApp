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
}
final class StarshipsViewModel:StarshipsViewModelProtocol{
    private var starships:[Starship]?
    private let networkService:NetworkServiceProtocol
    init(networkService:NetworkServiceProtocol) {
        self.networkService=networkService
    }
    var bindStarshipsToViewController: () -> Void={}
    func fetchStarships() {
        networkService.fetchData(from: "starships/") {[weak self] (result:Result<StarshipResponse,NetworkError>) in
            switch result{
                case .failure(let error):
                    print(error)
                case .success(let data):
                    self?.starships=data.results ?? []
                    self?.bindStarshipsToViewController()
            }
        }
    }
    
    func getStarships()->[Starship] {
        return starships ?? []
    }
    
    func getStarshipsCount() -> Int {
        return starships?.count ?? 0
    }
    
}
