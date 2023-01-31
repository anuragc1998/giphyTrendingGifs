//
//  GiphyNetworkService.swift
//  GifyAssignment
//
//  Created by macbook on 28/01/23.
//

import Foundation

// Interface for interacting with network layer
protocol NetworkService{
    func loadGifsData(offset: Int, completionHandler: @escaping (GiphyData?, NSError?)->Void)
}

// Entity responsible for loading gifs
class GiphyNetworkService: NetworkService{
    
    var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // load gifs and return response, error pair for further processing
    func loadGifsData(offset: Int = 0,completionHandler: @escaping (GiphyData?, NSError?)->Void) {
        let url = Constants.Endpoint.giphyEndpoint.path
        
        networkManager.apiRequestWithDetails(isAuthentication: false, urlString: url, method: .get, ["offset":"\(offset)", "limit":"10", "api_key":"\(Constants.GiphyAPIKey)"], decodingType: GiphyData.self, isDecodable: true) { response, error, jsonResponse in
            guard error == nil else {
                completionHandler(nil, error as NSError?)
                return
            }
            
            guard let user_result = response as? GiphyData, let _ = user_result.data else {
                completionHandler(nil, error as NSError?)
                return
            }
            
            completionHandler(user_result, nil)

        }
    }
}
