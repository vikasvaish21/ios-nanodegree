//
//  udacity.swift
//  OnTheMap
//
//  Created by vikas on 18/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
enum Udacity {
    
    static var accountKey: String?
    static var sessionID: String?
    static var user: UdacityGetUserResponse?
    
    static func resetValues() {
    Udacity.accountKey = nil
    Udacity.sessionID = nil
        Udacity.user = nil
    }
}
