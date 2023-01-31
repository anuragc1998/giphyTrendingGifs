//
//  GifyAssignmentTests.swift
//  GifyAssignmentTests
//
//  Created by macbook on 27/01/23.
//

import XCTest
@testable import GifyAssignment

final class GifyAssignmentTests: XCTestCase {

    // testing entity is viewmodel
    var sut: GiphyViewModel?
    // use test version of network service
    var networkService: MockGiphyNetworkService?
    
    // block that runs before each test
    override func setUpWithError() throws {
        networkService = MockGiphyNetworkService()
        guard let networkService else {return}
        // testing network service only
        sut = GiphyViewModel(gifLoader: networkService, dbHandler: nil)
    }

    // called after each test, dispose the entities
    override func tearDownWithError() throws {
        networkService = nil
        sut = nil
    }

    // test view model for empty json
    func testEmptyJson(){
        
        networkService?.result = networkService?.getJsonData()
        networkService?.error = NSError(domain: "gifyDomainError", code: 404)
        
        sut?.loadGifs(completionHandler: { status in
            // check for request status and data count
            XCTAssertTrue(!(status ?? false))
            XCTAssert(self.sut?.giphyData.count == 0)
        })
        
    }
    
    // test view model for invalid json
    func testInvalidJson(){

        var jsonString = """
          {"data":
            {"type":"gif","id":"0T6UvKtAyu6GhmCg4F","url":"https://giphy.com/gifs/miamiheat-miami-heat-0T6UvKtAyu6GhmCg4F"},
             {"type":"gif","id":"0T6UvKtAyu6GhmCg4G","url":"https://giphy.com/gifs/miamiheat-miami-heat-0T6UvKtAyu6GhmCg4T"}]
          }
          """
        networkService?.result = networkService?.getJsonData(jsonString: jsonString)
        networkService?.error = nil
        
        sut?.loadGifs(completionHandler: { status in
            // check for request status and data count
            XCTAssertTrue(!(status ?? false))
            XCTAssert(self.sut?.giphyData.count ?? 0 == 0)
        })
    }
    
    
    // test view model for valid json
    func testValidJson(){
        
        var jsonString = """
          {"data":
            [{"type":"gif","id":"0T6UvKtAyu6GhmCg4F","url":"https://giphy.com/gifs/miamiheat-miami-heat-0T6UvKtAyu6GhmCg4F"},
             {"type":"gif","id":"0T6UvKtAyu6GhmCg4G","url":"https://giphy.com/gifs/miamiheat-miami-heat-0T6UvKtAyu6GhmCg4T"}]
          }
          """
        networkService?.result = networkService?.getJsonData(jsonString: jsonString)
        networkService?.error = nil
        
        sut?.loadGifs(completionHandler: { status in
            // check for request status and data count
            XCTAssertTrue(status ?? false)
            XCTAssert(self.sut?.giphyData.count ?? 0 == 2)
        })
        
    }

}
