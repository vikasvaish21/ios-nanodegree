//
//  FlickerAPI.swift
//  VirtualTourist
//
//  Created by vikas on 29/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
class FlickerAPI {
    let session = URLSession.shared
    static let shared = FlickerAPI()
    
    private func URLParameters(parameters: [String:AnyObject]) -> URL{
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.Flickr.APIScheme
        urlComponents.host = Constants.Flickr.APIHost
        urlComponents.path = Constants.Flickr.APIBaseURL
        urlComponents.queryItems = [URLQueryItem]()
        
        for (key,value) in parameters{
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems!.append(queryItem)
        }
        return urlComponents.url!
    }
    private func getparaPair(pin : Pin) -> Dictionary<String,Any>{
        return[
            Constants.FlickrParameterKeys.Method:Constants.FlickrParameterValues.PhotosSearchMethod,
            Constants.FlickrParameterKeys.APIKey:Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.Extras:Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format:Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback:Constants.FlickrParameterValues.DisableJSONCallback,
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.SafeSearch,
            Constants.FlickrParameterKeys.BoundingBox: getbbox(pin: pin)
        ]
    }

    private func getbbox(pin:Pin) -> String{
        let minLong = max(pin.longitude - Constants.Flickr.SearchBoxWidth,Constants.Flickr.SearchLongRange.0)
        let minLat = max(pin.latitude - Constants.Flickr.SearchBoxHeight,Constants.Flickr.SearchLatRange.0)
        let maxLong = min(pin.longitude + Constants.Flickr.SearchBoxWidth,Constants.Flickr.SearchLongRange.1)
        let maxlat = min(pin.latitude + Constants.Flickr.SearchBoxHeight,Constants.Flickr.SearchLatRange.1)
        return "\(minLong),\(minLat),\(maxLong),\(maxlat)"
    }
    
    func createRequest(pin:Pin) -> URLRequest{
        return URLRequest(url: URLParameters(parameters: getparaPair(pin: pin) as [String:AnyObject]))
    }
    
    
    func getRequest(request:URLRequest,completionHandler: @escaping(_ result:NSArray?,_ error:String?) ->Void){
        let task = session.dataTask(with: request){
           ( data,response,error) in
            guard(error == nil) else{
            completionHandler(nil,"connection Error")
                return
        }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 &&
                statusCode <= 299 else{
                    completionHandler(nil,"your request return a status code other then in between the range")
                    return
            }
            
            guard let data = data else{
                completionHandler(nil,"no data was return by the api")
                return
            }
            
            let parseResult : [String:AnyObject]!
            do{
                parseResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as?
                    [String:AnyObject]
            }
            catch{
                completionHandler(nil,"json parsing couldn,t successful'\(data)'")
                return
            }
            
            guard let photoDictionary = parseResult?[Constants.FlickrResponseKeys.Photos] as?
            [String:AnyObject],let photoArray =  photoDictionary[Constants.FlickrResponseKeys.Photo]
                as? [[String:AnyObject]] else{
                    completionHandler(nil,"can not find keys: \(Constants.FlickrResponseKeys.Photos) in \(parseResult!)")
                    return
            }
            guard(photoArray.count > 0) else{
                completionHandler(nil,"no photos found!.Search again")
                return
            }
            completionHandler(photoArray as NSArray, nil)
            
    }
        task.resume()
}
    func downloadImage(imageUrl:String,completionHandler:@escaping(_ image: Data?,_ error:String?)-> Void){
        let task = session.dataTask(with: URL(string: imageUrl)!){
            (data,response,error) in
            guard(error == nil) else{
                completionHandler(nil,"connection error")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                
            completionHandler(nil,"your request status in not in between 200 to 299")
                return
        }
            completionHandler(data,nil)
    }
    task.resume()
}
}
