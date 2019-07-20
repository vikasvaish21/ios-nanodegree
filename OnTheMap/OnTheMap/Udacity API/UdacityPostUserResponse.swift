//
//  UdacityPostUserResponse.swift
//  OnTheMap
//
//  Created by vikas on 18/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
struct UdacityPostUserResponse:Codable {
    let account: Account?
    let session: Session?
    
    struct Account: Codable {
        let registered: Bool?
        let key: String?
    }
    
    struct Session: Codable {
        let id: String?
        let expiration: String?
    }
}
