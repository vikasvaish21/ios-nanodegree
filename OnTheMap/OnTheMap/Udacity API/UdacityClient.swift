//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by vikas on 18/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
class UdacityClient{
     static func GetUser(userID:String,completionHandler:@escaping (UdacityGetUserResponse?,String?)->Void){
        let url = Endpoints.userURL.appendingPathComponent(userID)
        let request = URLRequest(url: url)
        DataTaskController.performDataTask(with: request, responseType: [String:UdacityGetUserResponse].self, secured: true){
            (response, errorMessage) in
            completionHandler(response?["user"], errorMessage)
        }
    }
    
   static func PostSession(username:String,password:String,completionHandler:@escaping (UdacityPostUserResponse?,String?)->Void){
        let bodyJson = ["udacity":["username":username,"password":password]]
        let bodyJsonData = try! JSONSerialization.data(withJSONObject: bodyJson)
        var request = URLRequest(url:Endpoints.sessionURL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["content-Type":"application/json","Accept":"application/json"]
        request.httpBody = bodyJsonData
        DataTaskController.performDataTask(with: request, responseType: UdacityPostUserResponse.self, secured: true, completionHandler: completionHandler)
    }
    
    
    static func DeleteSession(CompletionHandler:@escaping(UdacityDeleteSessionResponse?,String?) -> Void) {
        
        var request = URLRequest(url: Endpoints.sessionURL)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
            break
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        DataTaskController.performDataTask(with: request, responseType: UdacityDeleteSessionResponse.self, secured: true, completionHandler: CompletionHandler)
       
    }
    
}
