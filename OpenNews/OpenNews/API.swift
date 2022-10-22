//
//  API.swift
//  OpenNews
//
//  Created by Taeyoung Son on 2022/10/15.
//

import Foundation

import RxSwift
import RxAlamofire
import Alamofire

final class API {
    private static let baseUrl = "https://6343b75cb9ab4243cad5ec9e.mockapi.io/"
    
    static func fetchAllArticles() -> Observable<[Article]> {
        let url = self.baseUrl.appending("articles")
        return RxAlamofire.request(.get, url)
            .validate(statusCode: 200..<300)
            .responseDecodable()
    }
}

public extension ObservableType where Element == DataRequest {
    func responseDecodable<T: Decodable>(of type: T.Type = T.self) -> Observable<T> {
        return self.flatMap { $0.rx.decodable() }
    }
}
