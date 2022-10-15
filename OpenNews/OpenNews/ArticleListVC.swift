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
