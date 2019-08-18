//
//  NetworkLog.swift
//  MarvelComics
//
//  Created by vikas on 10/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
class NetworkLogger{
    
    
    static func log (_ request:URLRequest){
        
        let urlString = request.url?.absoluteString ?? ""
        let urlComponent = NSURLComponents(string: urlString)
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")": ""
        let path = "\(urlComponent?.path ?? "")"
        let query = "\(urlComponent?.query ?? "")"
        let host = "\(urlComponent?.host ?? "")"
        
        var logOutput = """
        \(urlString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        Host: \(host)\n
        """
        
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key):\(value)\n"
        }
        if let body = request.httpBody{
            logOutput += (NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "") as
            String
        }
    }
    static func log (_ response:URLResponse){}
}
