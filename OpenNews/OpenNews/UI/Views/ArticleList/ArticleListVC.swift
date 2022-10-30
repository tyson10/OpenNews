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
        self.setRefreshControl()
    }
    
    override func bind(reactor: Reactor) {
        Observable.just(Void())
            .map { Reactor.Action.loadArticles }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.reload.share()
            .map { Reactor.Action.reload }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$sectionDatas).share()
            .bind(to: self.tableView.rx.items(dataSource: self.dataSourece))
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$isReloadEnded).share()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: self.endRefreshing)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(SectionModel.Item.self)
            .map(Reactor.Action.modelSelected)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    private func setTable() {
        self.tableView.rowHeight = 100
        self.tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.reuseableIdentifier)
    }
}

//MARK: - Refresh
extension ArticleListVC {
    private func setRefreshControl() {
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?
            .addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
    }
    
    @objc private func pullToRefresh() {
        self.reload.accept(())
    }
    
    private func endRefreshing() {
        self.tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - Section Model Type
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
