//
//  MarvelDataSource.swift
//  MarvelComics
//
//  Created by vikas on 10/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit
class MarvelDataSource{
    let cacheImages = NSCache<NSString,ImageCache>()
    static let sharedInstance = MarvelDataSource()
    private init (){}
}
