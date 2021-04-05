//
//  NetworkManager.swift
//  TestNewsApp
//
//  Created by пользователь on 4/3/21.
//

import Foundation
import Alamofire
import ObjectMapper

class NewsNetworkManager {
    
    static let shared = NewsNetworkManager()
    
    // MARK: - Initialization
    private init (){}
    
    // MARK: - Method
    func getNews(date: Date, completion: @escaping(_ newsList: NewsModel) -> (), failure: @escaping(_ error: Error) -> ())  {
        guard let url = URL(string: Constants.domain) else {return}
        let param = ["q": "apple",
                     "from": date.startOfDay.convertDateToString(),
                     "to": date.endOfDay.convertDateToString(),
                     "apiKey": Constants.token,
                     "sortBy": "publishedAt"]
        AF.request(url, method: .get, parameters: param).validate().responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let data = response.data {
                    guard let courses = Mapper<NewsModel>().map(JSONString: String(data: data, encoding: .utf8)!) else { return }
                    completion(courses)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}
