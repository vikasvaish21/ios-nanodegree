//
//  NetworkManager.swift
//  OnTheMap
//
//  Created by vikas on 18/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
class NetworkManager{
    
    
        static func loggedIn(){
        getUserPublicInfo()
        getStudentLocation(type: .myLocation){(location,errorMessage) in
            if let location = location?.first{
                Parse.objectID = location.objectId
                }
            }
        }
    
        static func loggedOut(){
            Parse.resetValues()
            Udacity.resetValues()
       }
    
     static func login(username:String,password: String,completionHandler:@escaping(_ error:String?)->Void){
        UdacityClient.PostSession(username:username,password:password){
            (response,errorMessage)in
            guard let response = response else{
                completionHandler(errorMessage)
                return
            }
            if let account = response.account,account.registered ?? false{
                Udacity.accountKey = account.key
                Udacity.sessionID = response.session?.id
                NetworkManager.loggedIn()
                completionHandler(nil)
            }
            else{
                completionHandler("invalid entries")
            }
        }
    }
    
  static func logout(completionHandler: @escaping (_ error:String?)->Void){
        UdacityClient.DeleteSession{(response,errorMessage) in
            loggedOut()
            completionHandler(errorMessage)
        }
    }
    
  static func getUserPublicInfo(){
        if let id = Udacity.accountKey{
            UdacityClient.GetUser(userID:id){(response,errorMessage) in
                Udacity.user = response
            }
        }
    }
    
    static func getStudentLocation(type: Parse.LocationType,completionHandler:@escaping([StudentLocationGetResponse]?,String?)->Void){
        switch type{
        case .allLocations:
            ParseClient.GetStudentLocation(completionHandler: completionHandler)
        case .myLocation:
            ParseClient.GetStudentLocation(with: Udacity.accountKey!, completionHandler: completionHandler)
            }
        }
    
    static func getUniqueStudentLocation(type:Parse.LocationType,completionHandler: @escaping ([StudentLocationGetResponse]?,String?)-> Void){
        NetworkManager.getStudentLocation(type: type){(response,errorMessage) in
            if errorMessage != nil{
                completionHandler(response,errorMessage)
            }
            else{
                let filteredResponse = self.getfilteredResponse(studentLocations: response!)
                switch type{
                case .allLocations:
                    Parse.studentLocations = filteredResponse
                case .myLocation:
                    break
                }
                completionHandler(filteredResponse,errorMessage)
            }
        }
    }
    
    
      static func getfilteredResponse(
        studentLocations:[StudentLocationGetResponse]) -> [StudentLocationGetResponse]{
        var set = Set<String>()
        var filtered = [StudentLocationGetResponse]()
        for item in studentLocations{
            if let key = item.uniqueKey,!set.contains(key){
                filtered.append(item)
                set.insert(key)
            }
        }
        return filtered
    }
    static func setStudentLocation(mapString:String,mediaURL:String,latitude:Float,longitude:Float,completionHandler:@escaping(_ error:String?)->Void){
        if let objectID = Parse.objectID{
            ParseClient.PutsStudentLocation(objectId: objectID, mapString: mapString, mediaUrl: mediaURL, latitude: latitude, longitude: longitude){
                (response,errorMessage) in
             completionHandler(errorMessage)
            }
        }
        else{
            ParseClient.PostStudentLocation(mapString: mapString, mediaUrl: mediaURL, latitude: latitude, longitude: longitude){
                                                (response,errorMessage) in
                                                guard let response = response else{
                                                    completionHandler(errorMessage)
                                                    return
                                                }
                                                Parse.objectID = response.objectId
                                                completionHandler(nil)

                }
        }
}
}

