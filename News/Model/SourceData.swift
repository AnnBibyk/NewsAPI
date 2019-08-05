//
//  SourceData.swift
//  News
//
//  Created by Anna Bibyk on 8/2/19.
//  Copyright © 2019 Anna Bibyk. All rights reserved.
//

import Foundation

/// MARK: - SourceData
struct SourceData: Codable {
    let sources: [SourceInfo]
}

// MARK: - Source
struct SourceInfo: Codable {
    let id, name: String
    let url: String
    enum CodingKeys: String, CodingKey {
        case id, name
        case url
    }
}

