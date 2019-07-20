//
//  DataTaskController.swift
//  OnTheMap
//
//  Created by vikas on 17/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit
enum DataTaskController{
    static let decodingFailMessage = "Failed to decode Server Response"
    
    static func performDataTask<T: Decodable>(with request: URLRequest,responseType:T.Type,secured:Bool,completionHandler:@escaping (T?,String?)->Void){
        let session = URLSession.shared
        let task  = session.dataTask(with: request){data,response,error in
            guard let data = data else{
                
                    completionHandler(nil,error!.localizedDescription)
               
                return
            }
            let status = (response as! HTTPURLResponse).statusCode
            guard status >= 200 && status <= 299 else{
                completionHandler(nil,"Invalid server  response:\(status)")
                return
            }
            let decoded = decodeDataToJSON(data: data,type: responseType, secured: secured)
            let message = decoded == nil ? decodingFailMessage: nil
            completionHandler(decoded,message)
        }
        task.resume()
    }
    
    
    
    static func decodeDataToJSON<T:Decodable>(data: Data,type: T.Type,secured: Bool) ->T?{
        let range = (secured ? 5:0)..<data.count
        let newData = data.subdata(in: range)
        let decoder = JSONDecoder()
        do{
            let decoded = try decoder.decode(type, from: newData)
            return decoded
        }
        catch{
            return nil
        }
        
    }
    
    static func showSimpleAlert(viewController: UIViewController, title:String,message:String){
        DispatchQueue.main.async {
             let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            viewController.present(alert,animated: true,completion: nil)
            
        }
    }
}
