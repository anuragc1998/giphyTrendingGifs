//
//  APIRequestManager.swift
//  GifyAssignment
//
//  Created by macbook on 27/01/23.
//

import Foundation

typealias APICompletionBlock = (_ response : Decodable?, _ error : Error?,_ jsonResponse: [String:AnyObject]?)->Void

// Can be used to mock and test generic network layer for invalid url, status code handlings etc.
protocol NetworkManager{
    func apiRequestWithDetails<T: Decodable>(isAuthentication : Bool,urlString:String,method:HTTPMethod,_ requestParams:Any?, decodingType: T.Type?,isDecodable:Bool, completionHandler:@escaping APICompletionBlock)
}

// Class for managing api calls comprising of network layer
public final class APIRequestManager: NetworkManager{
    
    var urlRequest: NetworkURLRequest?
    
    // create url request
    private func configureServiceRequest(url:String,method:HTTPMethod, apiParams:Any? =  nil)->NetworkURLRequest?{
        urlRequest = NetworkURLRequest(urlString: url, method: method,params : apiParams)
        urlRequest?.serviceRequest?.timeoutInterval = 20
        return urlRequest
    }
    
    //  login headers for authenticated apis
    private func getLoginHeader() -> String{
        if let header = UserDefaults.standard.string(forKey: "access_token"){
            print("Token is \(header)")
            return "Bearer \(header)"
        }
        return ""
    }
    
    // add default headers
    private func addDefaultHeaders(){
        urlRequest?.serviceRequest = urlRequest?.addDefaultHeader()
    }
    
    // return json for failed data decoding
    private func jsonSerialisedData(dataObject : Data,responseJSON:HTTPURLResponse)-> (json: [String:AnyObject]?, error: Error?){
        do {
            guard let json = try JSONSerialization.jsonObject(with: dataObject, options: []) as? [String:AnyObject] else {
                let errorInfo = [NSLocalizedDescriptionKey :NetworkError.defaultError]
                let errorJsonParsing = NSError(domain: Constants.GiphyErrorDomain, code: responseJSON.statusCode, userInfo: errorInfo)
                return (nil, errorJsonParsing)
            }
            return (json, nil)
        } catch let errorJsonSerial {
            // Error Call Back if json serialisation fails
            let errorInfo = [NSLocalizedDescriptionKey :errorJsonSerial]
            
            let errorJsonParsing = NSError(domain: Constants.GiphyErrorDomain, code: responseJSON.statusCode, userInfo: errorInfo)
            return (nil, errorJsonParsing)
        }
    }
    
    // generate url request and process it for interaction with network
    func apiRequestWithDetails<T: Decodable>(isAuthentication : Bool = false,urlString:String,method:HTTPMethod,_ requestParams:Any?, decodingType: T.Type?,isDecodable:Bool = true, completionHandler:@escaping APICompletionBlock){
        
        // check if proper url generated
        guard let apiRequest = configureServiceRequest(url: urlString, method: method,apiParams: requestParams) else  {
            print(NetworkError.requestNotInitialised)
            return
            
        }

        //Checking if Authorization is Required for API Request
        if isAuthentication{
            apiRequest.serviceRequest?.setValue(getLoginHeader(), forHTTPHeaderField: "iOS-Bearer")
            apiRequest.serviceRequest?.setValue(getLoginHeader(), forHTTPHeaderField: "Authorization")
        }
        
        urlRequest = apiRequest
        
        // start network request and return decodedData, error, json triplet accordingly
        urlSessionDataTask(decodingType: T.self,isDecodable:isDecodable) { (decodable, error, responseJson) in
            completionHandler(decodable,error,responseJson)
        }
    }
    
    // start network request and return decodedData, error, json triplet accordingly
    private func urlSessionDataTask<T: Decodable>(decodingType: T.Type?,isDecodable:Bool = true,completionHandler:@escaping APICompletionBlock){
       

        guard let _request = urlRequest?.serviceRequest else {return}
        
        // create session and start network request
        let session = URLSession.shared
        session.dataTask(with: _request, completionHandler: { (data, response, error) in
            
            //if error without decoding, return error without decoded data and json
            if let errorDetails = error {
                print("\n \n \n URL:  \(_request.url?.absoluteString ?? "")\nError Description:  %@ \n \n ", errorDetails.localizedDescription)
                let timeOutError : NSError = errorDetails as NSError
                if timeOutError.code == NSURLErrorTimedOut{
                    print(" \n \n \n URL:  \(_request.url?.absoluteString ?? "") \n Error Description:   \(errorDetails.localizedDescription) \n ")
                }
                
                let customError = NSError(domain: (response as? HTTPURLResponse)?.url?.host ?? "", code: (response as? HTTPURLResponse)?.statusCode ?? 404, userInfo: [NSLocalizedDescriptionKey : Constants.NetworkErrorString])
                DispatchQueue.main.async {
                    completionHandler(nil,customError,nil)
                }
                
            }else{
                
                
                if let responseJSON = response as? HTTPURLResponse,let dataObject = data{
                    
                    switch (responseJSON.statusCode){
                    // handle successful response
                    case HTTPResponseStatusCode.success.rawValue:
                        if let decodingProvided = decodingType, isDecodable{
                            // try decoding and return decoded data
                            // return json data if failure
                            do {
                                let genericModel = try JSONDecoder().decode(decodingProvided, from: dataObject)
                                //send decoded model if decoding gets succeeded
                                DispatchQueue.main.async {
                                    completionHandler(genericModel, nil,nil)
                                }
                            } catch let error {
                                //json parsing error
                                //send json response if provided codable decoding error
                                print("Swift Decoding Error: \(error)")
                                let serialisedDetails = self.jsonSerialisedData(dataObject: dataObject, responseJSON: responseJSON)
                                DispatchQueue.main.async {
                                    completionHandler(nil,serialisedDetails.error,serialisedDetails.json)
                                }
                            }
                        }else{
                            //send json response if isDecodable is provided as false
                            let serialisedDetails = self.jsonSerialisedData(dataObject: dataObject, responseJSON: responseJSON)
                            
                            DispatchQueue.main.async {
                                completionHandler(nil,serialisedDetails.error,serialisedDetails.json)
                            }
                        }
                    // Handle 201 status code
                    case HTTPResponseStatusCode.success201.rawValue:
                        let serialisedDetails = self.jsonSerialisedData(dataObject: dataObject, responseJSON: responseJSON)
                        DispatchQueue.main.async {
                            completionHandler(nil,serialisedDetails.error,serialisedDetails.json)
                        }
                    // Handle 304 - not modified status code
                    case HTTPResponseStatusCode.notModified.rawValue:
                        let errorInfo = [NSLocalizedDescriptionKey :NetworkError.notModified]
                        let networkError = NSError(domain: Constants.GiphyErrorDomain, code: responseJSON.statusCode, userInfo: errorInfo)
                        DispatchQueue.main.async {
                            completionHandler(nil,networkError,nil)
                        }
                    // Handle 404 - not found status code
                    case HTTPResponseStatusCode.notFound.rawValue:
                        let errorInfo = [NSLocalizedDescriptionKey :NetworkError.requestNotFound]
                        let networkError = NSError(domain: Constants.GiphyErrorDomain, code: responseJSON.statusCode, userInfo: errorInfo)
                        DispatchQueue.main.async {
                            completionHandler(nil,networkError,nil)
                        }
                    // Handle 503 - internal server error
                    default:
                        let serialisedDetails = self.jsonSerialisedData(dataObject: dataObject, responseJSON: responseJSON)
                        var  errorInfo = [NSLocalizedDescriptionKey :NetworkError.defaultError]
                        var networkError : Error?
                        if serialisedDetails.error != nil{
                            networkError = serialisedDetails.error
                            
                        }else if let messageDetails = serialisedDetails.json?["message"] as? String {
                            errorInfo = [NSLocalizedDescriptionKey :messageDetails]
                            networkError  = NSError(domain: Constants.GiphyErrorDomain, code: responseJSON.statusCode, userInfo: errorInfo)
                            
                        }else {
                            let messageDetails = serialisedDetails.json?["message"] as? [String:AnyObject]
                            errorInfo = [NSLocalizedDescriptionKey :messageDetails?["text"] as? String ?? NetworkError.defaultError]
                            networkError  = NSError(domain: Constants.GiphyErrorDomain, code: responseJSON.statusCode, userInfo: errorInfo)
                        }
                        DispatchQueue.main.async {
                            completionHandler(nil,networkError,nil)
                        }
                    }
                    
                }else{
                    // Handle improper network response
                    let errorInfo = [NSLocalizedDescriptionKey :NetworkError.nilHTTPURLResponse]
                    let networkError = NSError(domain: Constants.GiphyErrorDomain, code: 912, userInfo: errorInfo)
                    DispatchQueue.main.async {
                        completionHandler(nil,networkError,nil)
                    }
                }
            }
        }).resume()
    }
}
