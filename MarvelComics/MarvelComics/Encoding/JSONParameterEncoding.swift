//
//  JSONParameterEncoding.swift
//  MarvelComics
//
//  Created by vikas on 11/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
public struct JSONParameterEncoding: ParameterEncoder{
    public static func encode(urlRequest: inout URLRequest, with parameter: parameters) throws {
        do{
            let jsonASData = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
            urlRequest.httpBody = jsonASData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }catch{
            throw ParameterEncodeError.encodingFailed
        }
    }
}
