//
//  MockNetworkService.swift
//  GifyAssignmentTests
//
//  Created by macbook on 31/01/23.
//


// Moved mock network service in test target from app target
import Foundation
@testable import GifyAssignment

// test network service
class MockGiphyNetworkService: NetworkService{
    
    // helper variables to mock and return network response and error
    var result: GiphyData?
    var error: NSError?
    
    func loadGifsData(offset: Int = 0,completionHandler: @escaping (GiphyData?, NSError?) -> Void) {
        // generate and return giphy data and error for view model and service testing
        completionHandler(result, error)
    }
    
    // helper to convert json string into required format
    func getJsonData(jsonString: String = "") -> GiphyData? {
        let JSONString = jsonString
        print(JSONString)
        let jsonData = JSONString.data(using: .utf8)!
        do {
          let data = try JSONDecoder().decode(GiphyData.self, from: jsonData)
          return data
        }
        catch _{
          return nil
        }
    }
    
}
