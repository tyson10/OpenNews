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
    var imageUrl: String?
    var imageUrlData: URL? {
        get {
            guard let str = self.imageUrl else { return nil }
            return URL(string: str)
        }
        set {
            self.imageUrl = newValue?.absoluteString
        }
    }
}
