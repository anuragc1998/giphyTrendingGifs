//
//  NetworkURLRequest.swift
//  GifyAssignment
//
//  Created by macbook on 27/01/23.
//

import Foundation
import UIKit

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

// network error strings created for improper http response code
public struct NetworkError {
     static let nilRequestPath         = "Request path is nil."
     static let defaultError           = "Something went wrong. Please try again later."
     static let noInternetConnection   = "No internet connection"
     static let requestNotInitialised  = "Request Object Nil"
     static let unableToDecode         = "Something went wrong. Please try again."
     static let requestNotFound        = "Api Request Not Found"
     static let notModified            = "Something went wrong. Please try later."
     static let nilHTTPURLResponse     = "An error occurred. Please try again later."
}

// for iterating over response codes
public enum HTTPResponseStatusCode: Int {
    case success       =  200
    case success201       =  201
    case notModified   =   304
    case notFound   =   404
    case nilHTTPURLResponse =  503
}

public class NetworkURLRequest
{
    // default timeout and request
    var timeoutInterval : TimeInterval = 20
    var serviceRequest : URLRequest?
    
    // create request based on url, param and request type
    init(urlString :String,method:HTTPMethod, params :Any? = nil) {
        guard let url = URL(string: urlString) else {
            print("Not a valid url")
            return
        }
        // handle get request and generate query string if needed
        if method == .get {
            var components = URLComponents(string: urlString)!
            if let requestParams = params as? [String:String]{
                components.queryItems = requestParams.map { (key, value) in
                    URLQueryItem(name: key, value: value)
                }
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            serviceRequest = URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeoutInterval)
        }else{
            //handle other requests and generate http body data from params if needed
            serviceRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeoutInterval)
            if let requestParams = params as? [String:Any]{
            
                if let httpBody = try? JSONSerialization.data(withJSONObject: requestParams, options: [])  {
                    serviceRequest?.httpBody = httpBody
                }

            }
            else if let requestParams = params as? [[String: Any]]{
                if let httpBody = try? JSONSerialization.data(withJSONObject: requestParams, options: [])  {
                    serviceRequest?.httpBody = httpBody
                }
            }
            else{
                
            }
        }
        
        serviceRequest?.httpMethod = method.rawValue
        serviceRequest = addDefaultHeader()
    }
  
    
    func addDefaultHeader()-> URLRequest? {
        guard let request = serviceRequest else { return nil}
        return addDefaultHeader(to: request)
    }
    
    //  default headers
    func addDefaultHeader(to request : URLRequest )-> URLRequest{
        var mutableRequest = request
        
        mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableRequest.setValue(UIDevice.current.name, forHTTPHeaderField: "model")
        mutableRequest.setValue("IOS", forHTTPHeaderField: "brand")
        mutableRequest.setValue(UIDevice.current.identifierForVendor?.uuidString ?? "", forHTTPHeaderField: "device-id")
        
        // increamental build number for facilitating backend to conditionally block/send in api response based on appCode and/or appVersion for fallback and other cases
        mutableRequest.setValue("\(Bundle.main.infoDictionary?["CFBundleVersion"] ?? -1)", forHTTPHeaderField: "appCode")
        mutableRequest.setValue("\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "1.0")", forHTTPHeaderField: "appVersion")
        return mutableRequest
        
    }
}
