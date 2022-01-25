//
//  RedditServices.swift
//  TheForkChallenge
//
//  Created by Manuel Alvarez on 1/25/22.
//

import Foundation

class RestaurantsServices {
    
//    MARK: - Request:
    private func fetchNewsRequest() -> RequestSettings {
        let url: String = "https://alanflament.github.io/TFTest/test.json"
        
        return RequestConfigurationFactory.createRequestSettings(encodingType: .body,
                                                                 url: url,
                                                                 method: .get)
    }
    
//  MARK: - API Call:
    func getRestaurants(completion: @escaping(Result<APIData, ServiceError>) -> Void){
        APIManager.execute(resource: fetchNewsRequest(), type: APIData.self) { (result) in
            switch result {
                case .success(let restourants):
                    completion(.success(restourants))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
