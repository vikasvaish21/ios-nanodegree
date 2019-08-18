//
//  EndPointsType.swift
//  MarvelComics
//
//  Created by vikas on 09/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
 protocol EndPointsType{
    var baseURL: URL{ get }
    var path: String { get }
    var httpMethod : HTTPMethod{ get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? {get}
    
}

enum HTTPMethod:String{
    case get = "GET"
    case Post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum HTTPTask{
    case request
    case requestParameters(bodyParameters: parameters?, urlParameters: parameters?)
    case requestparameterAndHeaders(bodyParameters: parameters?,urlParameters: parameters?,
        additionHeaders: HTTPHeaders?)
    case download(_ url: String)
}

typealias HTTPHeaders = [String:String]


