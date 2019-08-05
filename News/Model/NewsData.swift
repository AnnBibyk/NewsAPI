//
//  NewsData.swift
//  News
//
//  Created by Anna Bibyk on 8/2/19.
//  Copyright © 2019 Anna Bibyk. All rights reserved.
//

import Foundation

// MARK: - NewsData
struct NewsData: Codable {
    let articles: [NewsArticle]
}

// MARK: - NewsArticle
struct NewsArticle: Codable {
    let source: Source
    let title, articleDescription: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case source, title
        case articleDescription = "description"
        case url
    }
}

// MARK: - Source
struct Source: Codable {
    let name: String
}

