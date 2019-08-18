//
//  ImageCache.swift
//  MarvelComics
//
//  Created by vikas on 10/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation
import UIKit
class ImageCache: NSObject , NSDiscardableContent {
    
    public var image:UIImage
    
    init(_ image:UIImage) {
        self.image = image
    }
    
    func beginContentAccess() -> Bool {
        return true
    }
    func endContentAccess() {
        
    }
    func discardContentIfPossible() {
        
    }
    func isContentDiscarded() -> Bool {
        return false
    }
}
