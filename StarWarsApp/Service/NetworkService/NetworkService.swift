//
//  NetworkService.swift
//  StarWarsApp
//
//  Created by Israa Assem on 30/07/2024.
//

import Foundation
import Alamofire
protocol NetworkServiceProtocol{
    func fetchData<T:Decodable>(from endpoint:String,completion:@escaping(Result<T,NetworkError>)->Void)
}
class NetworkService:NetworkServiceProtocol{
    static let shared=NetworkService()
    private init(){}
    private let BASE_URL="https://swapi.dev/api/"
    func fetchData<T>(from endpoint: String, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        guard let url=URL(string: BASE_URL+endpoint) else{
            print("Invalid url.")
            completion(.failure(.invalidURL))
            return
        }
        AF.request(url).validate().cacheResponse(using: .cache).responseDecodable(of:T.self)
            {response in
                switch response.result{
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        switch error{
                            case .responseSerializationFailed(let reason):
                                completion(.failure(.unableToDecodeResponse(reason)))
                            case .sessionTaskFailed(let reason):
                                completion(.failure(.requestFailed(reason)))
                            case .responseValidationFailed(let reason):
                                completion(.failure(.invalidResponse(reason)))
                            default:
                                completion(.failure(NetworkError.unknownError(error)))
                        }
                }
        }
    }
}
enum NetworkError:Error{
    case invalidURL
    case invalidResponse(AFError.ResponseValidationFailureReason)
    case unableToDecodeResponse(AFError.ResponseSerializationFailureReason)
    case requestFailed(Error)
    case unknownError(Error)
}
