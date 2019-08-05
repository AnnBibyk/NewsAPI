//
//  NewsAPI.swift
//  News
//
//  Created by Anna Bibyk on 8/2/19.
//  Copyright © 2019 Anna Bibyk. All rights reserved.
//

import Foundation

class NewsAPI {
    
    static var baseURL = URLComponents(string: "https://newsapi.org")
    static let keyAPI = "60ce48fcf9924520a5f32c1eea7cf9ee"
    
    enum Endpoints {
        case articles(source : String)
        case sources
        
        var url: URL? {
            switch self {
            case .articles(let source):
                let chosenSource = source
                NewsAPI.baseURL?.path = "/v2/top-headlines"
                NewsAPI.baseURL?.queryItems = [URLQueryItem(name: "sources", value: chosenSource),
                                               URLQueryItem(name: "apiKey", value: NewsAPI.keyAPI)]
                guard let url = NewsAPI.baseURL?.url else { return nil }
                return url
                
            case .sources:
                NewsAPI.baseURL?.path = "/v2/sources"
                NewsAPI.baseURL?.queryItems = [URLQueryItem(name: "apiKey", value: NewsAPI.keyAPI)]
                guard let url = NewsAPI.baseURL?.url else { return nil }
                return url
            }
        }
        
    }
    
    // MARK: - fetching articles
    
    class func requestArticlesData(source : String, complitionHandler: @escaping(NewsData, Error?) -> Void) {
        print("NewsAPI - \(source)")
        guard let finalURL = Endpoints.articles(source: source).url else { return }
        print(finalURL)
        
        let task = URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            guard let data = data else {
                print(error!)
                return
            }
            print(data)
            do {
                let decoder = JSONDecoder()
                let newsStruct = try decoder.decode(NewsData.self, from: data)
                complitionHandler(newsStruct, nil)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        task.resume()
    }
    
    // MARK: - fetching sources
    
    class func requestSourcesData(complitionHandler: @escaping(SourceData, Error?) -> Void) {
        guard let finalURL = Endpoints.sources.url else { return }
        
        let task = URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            guard let data = data else {
                print(error!)
                return
            }
            do {
                let decoder = JSONDecoder()
                let sourcesStruct = try decoder.decode(SourceData.self, from: data)
                complitionHandler(sourcesStruct, nil)
            } catch {
                print("Error: trying to convert SourceData to JSON")
                return
            }
        }
        task.resume()
    }
}
