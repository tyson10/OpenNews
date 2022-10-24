//
//  Article.swift
//  OpenNews
//
//  Created by Taeyoung Son on 2022/10/10.
//

import Foundation

struct Article: Codable {
    var id: String
    var title: String
    var imagePath: String?
    var newsPath: String?
}
