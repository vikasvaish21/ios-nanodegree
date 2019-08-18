//
//  URLParameter.swift
//  MarvelComics
//
//  Created by vikas on 11/08/19.
//  Copyright © 2019 project1. All rights reserved.
//
import Foundation

//Takes parameters and make them safe to be passed as URL Parameters
public struct URLParameterEncoder:ParameterEncoder{
    public static func encode(urlRequest: inout URLRequest, with parameter: parameters) throws {
        guard let url = urlRequest.url else {
            throw ParameterEncodeError.missingURL}
        guard !parameter.isEmpty else { throw
            ParameterEncodeError.parametersNil}
        if var urlcomponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlcomponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameter{
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlcomponents.queryItems?.append(queryItem)
                
        }
            urlRequest.url = urlcomponents.url
        }
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil{
            urlRequest.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
        }
    }
}
