//
//  StudentLocationGetResponse.swift
//  OnTheMap
//
//  Created by vikas on 17/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
struct StudentLocationGetResponse: Codable {
   let createdAt: String?
   let firstName: String?
   let  lastName: String?
   let  latitude: Float?
   let longitude: Float?
   let mapString: String?
   let  mediaURL: String?
   let  objectId: String?
   let uniqueKey: String?
   let updatedAt: String?
}
