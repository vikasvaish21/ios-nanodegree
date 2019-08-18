//
//  Router.swift
//  MarvelComics
//
//  Created by vikas on 09/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
class Router<EndPoint: EndPointsType>:NetworkRouter{
    private var task : URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkCompletionHandler) {
        let session = URLSession.shared
        do{
            let request = try buildRequest(from: route)
            NetworkLogger.log(request)
            task = session.dataTask(with: request, completionHandler: completion)
        }
        catch{
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
}

extension Router{
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest{
        var request = URLRequest(url:route.baseURL.appendingPathComponent(route.path),cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue
        
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(bodyParameters: let bodyParameters, urlParameters: let urlParameters):
                try configureParameters(bodyParameters:bodyParameters,urlParameters: urlParameters,request: &request)
                
            case .requestparameterAndHeaders(bodyParameters: let bodyParameters, urlParameters: let urlParameters, additionHeaders: let additionHeaders): addAdditionalHeader(additionHeaders,request: &request)
                try configureParameters(bodyParameters:bodyParameters,urlParameters:urlParameters,request:&request)
            case .download:
                request.url = route.baseURL
            }
            return request
        } catch{
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: parameters?,urlParameters: parameters?,request: inout URLRequest) throws {
        do{
            if let bodyParameters = bodyParameters{
                try JSONParameterEncoding.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters{
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        }catch{
            throw error
        }
    }
    
    fileprivate func addAdditionalHeader(_ additionalHeader : HTTPHeaders?,request: inout URLRequest){
        guard let headers = additionalHeader else{ return }
        
        for(key,value) in headers{
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    
}
