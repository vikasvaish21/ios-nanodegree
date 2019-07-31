//
//  Constants.swift
//  VirtualTourist
//
//  Created by vikas on 29/07/19.
//  Copyright © 2019 project1. All rights reserved.
//

struct Constants {
    struct Flickr {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIBaseURL = "/services/rest"
        
        static let SearchBoxWidth = 1.0
        static let SearchBoxHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLongRange = (-180.0, 180.0)
    }
    
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let page = "page"
        static let pages = "pages"
    }
    struct FlickrParameterValues {
        static let PhotosSearchMethod = "flickr.photos.search"
        static let APIKey = "998cf3038480c0adfbf7f447651cb4d3"
        static let MediumURL = "url_m"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "nojsoncallback"
        static let SafeSearch = "1"
    }
    
    struct FlickrResponseKeys {
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let ImageUrl = "url_m"
        static let Status = "status"
    }
}
