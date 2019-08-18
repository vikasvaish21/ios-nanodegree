//
//  ActionDetail.swift
//  MarvelComics
//
//  Created by vikas on 14/08/19.
//  Copyright © 2019 project1. All rights reserved.
//

import Foundation


public enum HeroDetailsType{
    case comic
    case serie
    case storie
}

extension HeroDetailsType{
    var path: String{
        switch self {
        case .comic:
            return "comics"
        case .serie:
            return "series"
        case .storie:
            return "stories"
        }
    }
}

struct ActionDataWrapper: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: ActionDetailsContainer?
}

struct ActionDetailsContainer: Codable {
    let offset, limit, total, count:Int?
    let results: [ActionDetails]?
}

struct ActionDetails : Codable {
    let id: Int?
    let title: String?
    let description: String?
    let isbn: String?
    let pageCount: Int?
    let urls: [URLElement]?
    let thumbnail: Thumbnail?
    let dates: [DateElement]?
}
struct DateElement:Codable {
    let type: String?
    let date: String?
}
