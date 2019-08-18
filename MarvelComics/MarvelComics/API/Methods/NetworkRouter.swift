//
//  NetworkRouter.swift
//  MarvelComics
//
//  Created by vikas on 09/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
public typealias NetworkCompletionHandler = (_ data: Data?,_ response:URLResponse?,_ error: Error?) -> ()
protocol NetworkRouter: class{
    associatedtype EndPoint:EndPointsType
    
    func request(_ router: EndPoint,completion:@escaping NetworkCompletionHandler)
    func cancel()
}
