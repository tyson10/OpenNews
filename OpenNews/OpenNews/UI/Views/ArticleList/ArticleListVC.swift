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
import SnapKit

final class ArticleListVC: ReactorBaseController<ArticleListVC.Reactor> {
    private let tableView = UITableView()
    private var dataSourece = RxTableViewSectionedReloadDataSource<SectionModel> { dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.reuseableIdentifier, for: indexPath) as! TableCell
        cell.configure(with: dataSource[indexPath])
        return cell
    }
    
    override func addSubviews() {
        self.view.addSubview(self.tableView)
    }
    
    override func addConstraints() {
        let safe = self.view.safeAreaLayoutGuide
        self.tableView.snp.makeConstraints {
            $0.edges.equalTo(safe)
        }
    }
    
    override func setAttrs() {
        self.view.backgroundColor = .white
        self.setTable()
    }
    
    override func bind(reactor: Reactor) {
        Observable.just(Void())
            .map { Reactor.Action.loadArticles }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$sectionDatas).share()
            .bind(to: self.tableView.rx.items(dataSource: self.dataSourece))
            .disposed(by: self.disposeBag)
    }
    
    private func setTable() {
        self.tableView.rowHeight = 100
        self.tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.reuseableIdentifier)
    }
}

extension ArticleListVC {
    final class Reactor: ReactorKit.Reactor {
        typealias SectionModel = ArticleListVC.SectionModel
        typealias SectionItem = SectionModel.Item
        
        var initialState: State = .init()
        
        enum Action {
            case loadArticles
        }
        
        enum Mutation {
            case setSectionDatas([SectionModel])
        }
        
        struct State {
            @Pulse var sectionDatas = [SectionModel]()
        }
        
        func mutate(action: Action) -> Observable<Mutation> {
            switch action {
            case .loadArticles:
                let sectionDatas = API.fetchAllArticles().map(self.makeSectionDatas(with:))
                return sectionDatas.map(Mutation.setSectionDatas)
            }
        }
        
        func reduce(state: State, mutation: Mutation) -> State {
            var new = state
            
            switch mutation {
            case .setSectionDatas(let sectionDatas):
                new.sectionDatas = sectionDatas
            }
            
            return new
        }
        
        private func makeSectionDatas(with articles: [Article]) -> [SectionModel] {
            var items: [SectionItem] = articles
            return [.basic(items: items)]
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
