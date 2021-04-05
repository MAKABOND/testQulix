//
//  NewsModel.swift
//  TestNewsApp
//
//  Created by пользователь on 4/3/21.
//

import Foundation
import ObjectMapper

class NewsModel: Mappable {
    
    var status : String?
    var totalResults: Int?
    var articles: [Articles] = []
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        status <- map["status"]
        totalResults <- map["totalResults"]
        articles <- map["articles"]
    }
}

class Articles: Mappable {
    
    var source: SourceModel?
    var author : String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        source <- map["source"]
        author <- map["author"]
        title <- map["title"]
        description <- map["description"]
        url <- map["url"]
        urlToImage <- map["urlToImage"]
        publishedAt <- map["publishedAt"]
        content <- map["content"]
    }
}

class SourceModel: Mappable {
    
    var id : Int?
    var name: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

// MARK: - Extension
extension Articles {
    var defaultImageNews: UIImage? {
        if let image = UIImage(named: "image_news") {
            return image
        }
        return nil
    }
    
    var imageURL: URL? {
        if let urlToImage = urlToImage {
            return URL(string: urlToImage)
        }
        return nil
    }
    
    var newsDate: Date? {
        if let publishedAt = publishedAt {
            return publishedAt.converterStringToDate()
        }
        return nil
    }
}
