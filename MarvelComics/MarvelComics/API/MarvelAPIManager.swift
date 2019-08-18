//
//  MarvelAPIManager.swift
//  MarvelComics
//
//  Created by vikas on 10/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit

enum Result<T> {
    case success(T)
    case failure(String)
}

enum NetworkResponse:String{
    case success
    case authenticationError = "You need to be authenticated first"
    case badRequest = "Bad request"
    case outdated = "The url you requested is otdated"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We could not decode the response"
    case poorNetworkConnection = "Please check your network connection"
    case okStatusNotAvailable = "Marvel API returned an error"
    case imageNotAvailable = "Image is not available"
    
}

class MarvelAPIManager{
    static let sharedInstance  = MarvelAPIManager()
    private init (){}
    static let enviroment: NetworkEnviroment = .production
    static let credential = ""
    private let router = Router<MarvelApiContent>()
    
func getHeroDetail(type:HeroDetailsType ,heroID: Int , page: Int = 0, completion: @escaping (_ result: Result<ActionDetailsContainer>) -> Void) {
    let offset = page * MarvelApiContent.Constants.ParametersValues.Limit
    
    router.request(.getHeroDetail(type, heroID, offset)) { (data,response,error) in
        switch self.handleNetworkResponse(response,error)  {
        case .success:
            guard let responseData = data else{
                completion(.failure(NetworkResponse.noData.rawValue))
                return
            }
            do{
                let apiResponse = try JSONDecoder().decode(ActionDataWrapper.self, from: responseData)
                
                guard apiResponse.status == MarvelApiContent.Constants.ResponseValues.OKStatus else{
                    completion(.failure(NetworkResponse.okStatusNotAvailable.rawValue))
                    return
                }
                
                guard let HeroData = apiResponse.data else{
                    completion(.failure(NetworkResponse.noData.rawValue))
                    return
                }
                completion(.success(HeroData))
            }
            catch{
                completion(.failure(NetworkResponse.unableToDecode.rawValue))
            }
        case .failure(let networkFailureError):
            completion(.failure(networkFailureError))
        }
    }
}
    
    
    func getCharacters(nameStartWith:String? = nil, page:Int = 0,completion: @escaping(_ result:
        Result<HeroDetailContainer>) ->Void) {
        let offset = page * MarvelApiContent.Constants.ParametersValues.Limit
        router.request(.getCharacters(nameStartWith, offset)){
            (data,response,error) in let networkResponseResult = self.handleNetworkResponse(response, error)
            
            switch networkResponseResult {
            case .success:
                guard let responseData = data else{
                    completion(.failure(NetworkResponse.noData.rawValue))
                    return
                }
                do{
                    let apiResponse = try JSONDecoder().decode(HeroDataWrapper.self, from: responseData)
                    guard apiResponse.status == MarvelApiContent.Constants.ResponseValues.OKStatus else{
                    completion(.failure(NetworkResponse.okStatusNotAvailable.rawValue))
                    return
                }
                guard let heroesData = apiResponse.data else{
                    completion(.failure(NetworkResponse.noData.rawValue))
                    return
                }
                completion(.success(heroesData))
            } catch {
                completion(.failure(NetworkResponse.unableToDecode.rawValue))
            }
            case .failure(let networkFailureError):
            completion(.failure(networkFailureError))
        }
    }
}
    
    func downloadThumbnail(from url:String?,completion: @escaping (_ result: Result<UIImage?>)-> Void)
    {
        guard let url = url ,
            !url.contains(MarvelApiContent.Constants.ImageNotAvailable) else{
            completion(.failure(NetworkResponse.imageNotAvailable.rawValue))
            return
        }
        
        if let imageCache = MarvelDataSource.sharedInstance.cacheImages.object(forKey:url as NSString){
            completion(.success(imageCache.image))
            return
        }
        
        self.router.request(.downloadThumb(url), completion: { (data,response,error) in
            switch self .handleNetworkResponse(response, error) {
            case .success:
                guard let imageData = data else{
                    completion(.failure(NetworkResponse.failed.rawValue))
                    return
                }
                guard let uiImage = UIImage(data: imageData) else{
                    completion(.failure(NetworkResponse.failed.rawValue))
                    return
                }
                MarvelDataSource.sharedInstance.cacheImages.setObject(ImageCache(uiImage),forKey:
                    url as NSString)
                    completion(.success(uiImage))
                
            case .failure(let networkFailureError):
                completion(.failure(networkFailureError))
                }
        })
    }
}

extension MarvelAPIManager {
    fileprivate func handleNetworkResponse(_ response: URLResponse?, _ error: Error?) -> Result<Bool> {
        guard error == nil else {
            return .failure(NetworkResponse.poorNetworkConnection.rawValue)
        }
        guard let response = response as? HTTPURLResponse else {
            return .failure(NetworkResponse.failed.rawValue)
        }
        
        switch response.statusCode {
        case 200...299: return .success(true)
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
