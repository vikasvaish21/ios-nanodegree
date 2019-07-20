//
//  ParseClient.swift
//  OnTheMap
//
//  Created by vikas on 17/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
class ParseClient {
    static let appID = ""
    static let appKey = ""
    
    enum Endpoints{
    static let endpointURL = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")
    }
    
    class func GetStudentLocation(completionHandler: @escaping ([StudentLocationGetResponse]?,String?) -> Void){
        let limit = URLQueryItem(name: "limit", value: "100")
        let order = URLQueryItem(name: "order", value: "-updatedAt")
        var urlComponents = URLComponents(string: Endpoints.endpointURL!.absoluteString)
        urlComponents?.queryItems = [limit,order]
        performGetStudentLocation(url:(urlComponents?.url)!,completionHandler: completionHandler)
        
    }
        
    class func GetStudentLocation(with userId:String,completionHandler: @escaping([StudentLocationGetResponse]?,String?)->Void) {
        
        
        let url = Endpoints.endpointURL!.appendingPathComponent("where={\"uniqueKey\":\"\(userId)\"}")
        print(url.absoluteString)
        performGetStudentLocation(url: url,completionHandler: completionHandler)
        
    }
    class func performGetStudentLocation(url:URL,completionHandler: @escaping ([StudentLocationGetResponse]?,String?)->Void){
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["X-Parse-Application-Id":ParseClient.appID,
                                       "X-Parse-REST-API-Id": ParseClient.appKey]
        DataTaskController.performDataTask(with: request, responseType: [String:[StudentLocationGetResponse]].self, secured:false){
            (response,message) in
            let cleanedResponse = response?["results"]
            completionHandler(cleanedResponse,message)
        }
    }
    
 class func PostStudentLocation(mapString:String,mediaUrl:String,latitude:Float,longitude:Float,completionHandler:@escaping(StudentLocationPostResponse?,String?)->Void){
    performPostOrPutStudentlocation(url:Endpoints.endpointURL!,method:"POST",mapString:mapString,mediaURL:mediaUrl,latitude:latitude,longitude:longitude,completionHandler:completionHandler)
        
    }
    
    class func PutsStudentLocation(objectId: String, mapString:String,mediaUrl:String,latitude:Float,longitude:Float,completionHandler:@escaping(StudentLocationPutResponse?,String?)->Void){
        let url = Endpoints.endpointURL!.appendingPathComponent(objectId); performPostOrPutStudentlocation(url:url,method:"PUT",mapString:mapString,mediaURL:mediaUrl,latitude:latitude,longitude:longitude,completionHandler:completionHandler)
        
    }
    class func performPostOrPutStudentlocation<T: Decodable>(
        url: URL,method: String,mapString:String,mediaURL: String,latitude:Float,longitude:Float,completionHandler:@escaping(T?,String?)->Void){
        
        guard (T.self == StudentLocationPostResponse.self || T.self == StudentLocationPutResponse.self)
            && (method == "POST" || method == "PUT") else {
                completionHandler(nil, "Internal local error: Invalid request.")
                return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        request.allHTTPHeaderFields = ["X-Parse-Application-Id": ParseClient.appID,
                                       "X-Parse-REST-API-Key": ParseClient.appKey,
                                       "Content-Type": "application/json"]
        
        let bodyJson: [String : Any] = ["uniqueKey": Udacity.accountKey!,
                                        "firstName": (Udacity.user?.firstName ?? ""),
                                        "lastName": (Udacity.user?.lastName ?? ""),
                                        "mapString": mapString,
                                        "mediaURL": mediaURL,
                                        "latitude": latitude,
                                        "longitude": longitude]
        
        let bodyJsonData = try? JSONSerialization.data(withJSONObject: bodyJson)
        request.httpBody = bodyJsonData
        
        DataTaskController.performDataTask(with: request, responseType: T.self, secured: false,
                                completionHandler: completionHandler)
    }
    
    
}
