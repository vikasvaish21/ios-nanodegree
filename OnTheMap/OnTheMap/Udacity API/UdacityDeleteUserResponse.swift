//
//  UdacityDeleteUserResponse.swift
//  OnTheMap
//
//  Created by vikas on 18/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
struct UdacityDeleteSessionResponse: Codable {
    
    let session: Session?
    
    struct Session: Codable {
        let id: String?
        let expiration: String?
    }
}
