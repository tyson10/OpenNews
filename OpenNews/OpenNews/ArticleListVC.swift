//
//  ViewController.swift
//  OpenNews
//
//  Created by Taeyoung Son on 2022/10/09.
//

import UIKit

import RxSwift
import ReactorKit

final class ArticleListVC: UIViewController {
    var disposeBag: DisposeBag = .init()
    
    override func loadView() {
        super.loadView()
        self.reactor = Self.Reactor()
        self.reactor?.action.onNext(.loadArticles)
    }
    
    @IBAction func btnTapped(_ sender: Any) {
        if let url = URL(string: "https://6343b75cb9ab4243cad5ec9e.mockapi.io/articles"){
            var request = URLRequest.init(url: url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request){ (data, response, error) in
                guard let data = data else {return}
                print("data  \(data)")
                do {
                    let articles = try JSONDecoder().decode([Article].self, from: data)
                    print(articles)
                } catch {
                    print(error)
                }
                
            }.resume()
        }
    }
}

extension ArticleListVC: ReactorKit.View {
    func bind(reactor: Reactor) {
        
    }
}

extension ArticleListVC {
    final internal class Reactor: ReactorKit.Reactor {
        var initialState: State = .init()
        enum Action {
            case loadArticles
        }
        struct State {
            @Pulse var articles: [Article]?
        }
    }
}
