//
//  HeroDetails.swift
//  MarvelComics
//
//  Created by vikas on 09/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation

struct HeroDataWrapper: Codable {
    let code: Int?
    let status: String?
    let etag: String?
    let data: HeroDetailContainer?
}

struct HeroDetailContainer: Codable{
    let offset,limit,total,count:Int?
    let results: [Hero]?
}


struct Hero:Codable{
    let id:Int?
    let name, description:String?
    let modified: String?
    let thumbnail:Thumbnail?
    let resourceURI: String?
    let comics: Comics?
    let series: Series?
    let stories: Stories?
    let events: Events?
    let urls: [URLElement]?
}


    struct URLElement: Codable {
        let type: String?
        let url: String?
    }

    struct Thumbnail: Codable {
        let path: String?
        let ext: String?
        
        var url: String?{
            guard path != nil,ext != nil else {return nil}
            return path! + "/\(MarvelApiContent.Constants.ThumbnailStandardSize)." + ext!
        }
        var portraitUrl: String? {
            guard path != nil, ext != nil else { return nil }
            return path! + "/\(MarvelApiContent.Constants.ThumbnailPortraitSiza)." + ext!
        }
        
        enum CodingKeys:String,CodingKey{
            case path
            case ext = "extension"
        }
    }

//events
struct Events:Codable {
    let available:Int?
    let collectionURI:String?
    let items: [EventsItem]?
    let returned: Int?
}
struct EventsItem:Codable {
    let resourceURI:String?
    let  name:String?
}

//Stories
struct Stories: Codable{
    let available:Int?
    let collectionURI:String?
    let items:[StoriesItem]?
    let returned: Int?
}

struct StoriesItem:Codable {
    let resourceURI: String?
    let name: String?
    let type: String?
}

//Series
struct Series:Codable {
    let available:Int?
    let collectionURI:String?
    let items:[SeriesItem]?
    let returned: Int?
}

struct SeriesItem: Codable {
    let resourceURI:String?
    let name: String?
}



//Comics
struct Comics:Codable {
    let available:Int?
    let collectionURI: String?
    let items:[ComicsItem]?
    let returned:Int?
}
struct ComicsItem:Codable {
    let resourceURI:String
    let name:String?
}
