//
//  ArticleEntity.swift
//  ArticleAppUsingViper
//
//  Created by 藤門莉生 on 2023/05/07.
//

import Foundation

struct ArticleEntity: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
