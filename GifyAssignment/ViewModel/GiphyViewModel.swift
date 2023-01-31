//
//  GiphyViewModel.swift
//  GifyAssignment
//
//  Created by macbook on 28/01/23.
//

import Foundation
import RealmSwift

class GiphyViewModel: ObservableObject{
    
    @ObservedResults(GiphyDatumRealm.self) var favouritesGiphys
    // inject network service to facilitate mocking
    var gifLoader: NetworkService
    // db handler for db handling
    var dbHandler: DBHandler?
    
    var totalCount : Int = 0
    var favouriteGiphyObjs: [GiphyDatum]{
        favouritesGiphys.map({GiphyDatum(data: $0)})
    }
    
    // data source for trending gifs
    @Published var giphyData : [GiphyDatum] = []
    
    // initialise dependencies, start db and fetch gifs
    init(gifLoader: NetworkService, dbHandler: DBHandler?) {
        self.gifLoader = gifLoader
        self.dbHandler = dbHandler
        
        self.dbHandler?.initializeDB()
        loadGifs { status in
            // post data dasks
        }
    }
    
    // fetch trending gifs
    func loadGifs(offset: Int = 0, completionHandler: @escaping (Bool?)->Void) {

        gifLoader.loadGifsData(offset: offset) { [weak self] response, error in
            // true completion status for valid response
            if let response, let self{
                self.totalCount = response.pagination?.totalCount ?? 0
                
                self.giphyData = response.data ?? []
                completionHandler(true)
            }
            // false completion status for invalid response, failure
            else{
                completionHandler(false)
            }
        }
        
    }
    
}
