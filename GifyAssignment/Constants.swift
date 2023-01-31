//
//  Constants.swift
//  GifyAssignment
//
//  Created by macbook on 27/01/23.
//

import Foundation

// constants used across the app
struct Constants {

    static let NetworkErrorString = "Something went wrong. Please try again later."
    static let GiphyErrorDomain = "GiphyErrorDomain"
    static let GiphyAPIKey = "cvlMVyfMEZL3wUoAKKcFaGZ6EMjFGyyA"
    
    enum Endpoint : String{
        case giphyEndpoint = "v1/gifs/trending"
        
        var path : String {
            return baseUrl + self.rawValue
        }
        
        var baseUrl : String {
            "https://api.giphy.com/"
        }
    }
    
    enum Tab : String {
        case home
        case favourites
    }
}
