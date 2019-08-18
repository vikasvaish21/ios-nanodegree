//
//  MarvelApi.swift
//  MarvelComics
//
//  Created by vikas on 05/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation


enum MarvelApiContent{
    case getCharacters(_ nameStartsWith:String?,_ offset: Int)
    case downloadThumb(_ fromUrl: String)
    case getHeroDetail(_ type: HeroDetailsType,_ heroID: Int,_ offset: Int)
}

extension MarvelApiContent: EndPointsType{
    var simpleBaseUrl:String{
        switch MarvelAPIManager.enviroment {
        case .production:
            return Constants.BaseURLProduction
        case .qa:
            return Constants.BaseURLQA
        case .staging:
            return Constants.BaseURLStaging
        }
    }
    public var baseURL: URL{
        var baseURL = ""
        switch self {
        case .downloadThumb(let url):
            baseURL = url
        default:
            baseURL = simpleBaseUrl
        }
        
        
        guard let url = URL(string: baseURL)  else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    public var path: String{
        switch self {
        case .getCharacters:
            return Constants.PathsMethods.Characters
        case .getHeroDetail(let type, let heroID, _):
            return Constants.PathsMethods.HeroArtifacts.replacingOccurrences(of: "{id}", with: "\(heroID)").replacingOccurrences(of: "{type}", with: "\(type.path)")
        default:
            return ""
        }
    }
    
    public var httpMethod: HTTPMethod{
        switch self {
        default:
            return .get
        }
    }
    
    public var task: HTTPTask{
        let ts = String(Date().timeIntervalSince1970)
        let commmonUrlParameters: parameters = [
            Constants.ParametersKeys.Ts: ts,
            Constants.ParametersKeys.APIKey: Constants.ParametersValues.APIKey,
            Constants.ParametersKeys.hash: "\(ts)\(MarvelApiContent.Constants.PrivateKey)\(MarvelApiContent.Constants.PublicKey)".MD5 ?? "",
            Constants.ParametersKeys.Limit: Constants.ParametersValues.Limit
        ]
        switch self {
        case .getCharacters(let nameStartWith, let offset):
            var urlParameters = commmonUrlParameters
            urlParameters[Constants.ParametersKeys.Offset] = offset
            if let nameStartWith = nameStartWith{
                urlParameters[Constants.ParametersKeys.NameStartsWith] = nameStartWith
            }
       return .requestParameters(bodyParameters: nil, urlParameters: urlParameters)
            
        case .getHeroDetail:
            return .requestParameters(bodyParameters: nil, urlParameters: commmonUrlParameters)
            
        case .downloadThumb(let url):
            return .download(url)
        }
    }
    public var headers: HTTPHeaders? {
        return nil
    }
   
}

extension MarvelApiContent {
    struct Constants {
        
        // MARK: - URL constants
        
        static let APIScheme = "https"
        static let APIHost = "gateway.marvel.com"
        static let APIPath = "/v1/public"
        static let BaseURLProduction = "\(APIScheme)://\(APIHost)\(APIPath)"
        static let BaseURLQA = ""
        static let BaseURLStaging = ""
        static let ThumbnailStandardSize = "standard_fantastic"
        static let ThumbnailPortraitSiza = "portrait_uncanny"
        static let ImageNotAvailable = "image_not_available"
        static let InfiniteScrollLimiar = 5
        static let DateFormat = "yyyy-MM-dd'T'HH:mm:ss-SSSS"
        
        // MARK: - Request constants
        
        static let PublicKey = "1b2a9f1fcda6b09b16e40484559b4c49"
        static let PrivateKey = "d1eb863f2affd1ef594c8f302adba24dc21cd2b3"
        
        // MARK: - Paths Methods
        
        struct PathsMethods {
            static let Characters = "/characters"
            static let HeroArtifacts = "/characters/{id}/{type}"
        }
        
        // MARK: - Parameters Keys
        
        struct ParametersKeys {
            static let Ts = "ts"
            static let APIKey = "apikey"
            static let hash = "hash"
            static let NameStartsWith = "nameStartsWith"
            static let Offset = "offset"
            static let Limit = "limit"
        }
        
        // MARK: - Parameters Values
        
        struct ParametersValues {
            static let APIKey = PublicKey
            static let Limit = 20
        }
        
        // MARK: - Response Values
        
        struct ResponseValues {
            static let OKStatus = "Ok"
        }
    }
}

