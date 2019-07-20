//
//  UdacityGetUserResponse.swift
//  OnTheMap
//
//  Created by vikas on 18/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
struct UdacityGetUserResponse:Codable{
    let firstName: String?
    let lastName: String?
    let nickname: String?
    let imageURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
        case imageURL = "_image_url"
    }

}
