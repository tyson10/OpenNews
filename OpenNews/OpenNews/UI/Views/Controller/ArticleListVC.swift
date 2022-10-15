//
//  ViewController.swift
//  OpenNews
//
//  Created by Taeyoung Son on 2022/10/09.
//

import UIKit

import RxSwift
import ReactorKit
import RxDataSources

final class ArticleListVC: ReactorBaseController<ArticleListVC.Reactor> {
    
    private var dataSourece = RxTableViewSectionedReloadDataSource<SectionModel> { dataSource, tableView, indexPath, item in
        return .init()
    }
    
    override func bind(reactor: Reactor) {
        Observable.just(Void())
            .map { Reactor.Action.loadArticles }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}

extension ArticleListVC {
    final class Reactor: ReactorKit.Reactor {
        var initialState: State = .init()
        enum Action {
            case loadArticles
        }
        struct State {
            @Pulse var sectionDatas = [ArticleListVC.SectionModel]()
        }
    }
}

extension ArticleListVC {
    enum SectionModel: SectionModelType {
        typealias Item = Article
        
        var items: [Article] {
            switch self {
            case .basic(let items): return items
            }
        }
        
        init(original: SectionModel, items: [Article]) {
            switch original {
            case .basic: self = .basic(items: items)
            }
        }
        
        case basic(items: [Article])
    }
}
