//
//  StarshipsViewModel.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import Foundation
import Combine
protocol StarshipsViewModelProtocol{
    func fetchStarships(pageNumber:Int)->Void
    func getStarships()->[Starship]
    func getStarshipsCount()->Int
    var bindStarshipsToViewController:()->Void{get set}
    var updateTable:()->Void{get set}
    func filterStarships(by searchText:String)->Void
    func setCurrentPage(pageNum:Int)->Void
    func getCurrentPage()->Int
    var showNetworkError:()->Void{ get set}
}
final class StarshipsViewModel:StarshipsViewModelProtocol{
    private var starships=[Starship]()
    private var filteredStarships=[Starship]()
    private let networkService:NetworkServiceProtocol
    private var currentPage=1
    var showNetworkError:()->Void
    init(networkService:NetworkServiceProtocol, showNetworkError: @escaping()->Void ){
        self.networkService=networkService
        self.showNetworkError=showNetworkError
    }
    var bindStarshipsToViewController: () -> Void={}
    var updateTable: () -> Void={}
    func fetchStarships(pageNumber:Int) {
        networkService.fetchData(from: "starships/?page=\(pageNumber)") {[weak self] (result:Result<StarshipResponse,NetworkError>) in
            switch result{
                case .failure(let error):
                    print(error)
                    self?.showNetworkError()
                case .success(let data):
                    self?.starships.append( contentsOf: data.results ?? [] )
                    self?.filteredStarships=self?.starships ?? []
                    self?.currentPage=pageNumber
                    self?.bindStarshipsToViewController()
            }
        }
        print("Page num: \(pageNumber)")
    }
    
    func getStarships()->[Starship] {
        return filteredStarships
    }
    
    func getStarshipsCount() -> Int {
        return filteredStarships.count
    }
    func setCurrentPage(pageNum:Int)->Void{
        currentPage=pageNum
    }
    func getCurrentPage()->Int{
        currentPage
    }
    func filterStarships(by searchText:String)->Void{
        if searchText.isEmpty{
            filteredStarships=starships
        }else{
            networkService.fetchData(from: "starships/?search=\(searchText)", completion: { [weak self](result:Result<StarshipResponse,NetworkError>) in
                switch result{
                    case .success(let data):
                        self?.bindStarshipsToViewController()
                        self?.filteredStarships=data.results ?? []
                    case .failure(let error):
                        print(error)
                        self?.showNetworkError()
                }
            })
        }
        updateTable()
    }
}
