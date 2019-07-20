//
//  Parse.swift
//  OnTheMap
//
//  Created by vikas on 18/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
enum Parse {
    
    
   static var objectID : String?
   static var studentLocations: [StudentLocationGetResponse]? = [StudentLocationGetResponse]()
    
    
    enum LocationType{
        case myLocation
        case allLocations
    }
    
    static func resetValues() {
        objectID = nil
    }
}
