//
//  ParameterEncoding.swift
//  MarvelComics
//
//  Created by vikas on 11/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
public typealias parameters = [String:Any]
public protocol ParameterEncoder{
    static func encode(urlRequest:inout URLRequest,with parameter:parameters) throws
}
public enum ParameterEncodeError:String,Error{
    case parametersNil = "Parameters were nil"
    case encodingFailed = "Parameters encoding failed"
    case missingURL = "URL is nil"
}
