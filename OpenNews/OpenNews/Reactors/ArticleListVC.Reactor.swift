//
//  ArticleListVC.Reactor.swift
//  OpenNews
//
//  Created by Taeyoung Son on 2022/10/30.
//

import Foundation

import RxSwift
import ReactorKit

extension ArticleListVC {
    final class Reactor: ReactorKit.Reactor {
        
        var initialState: State = .init()
        
        enum Action {
            case loadArticles
            case modelSelected(SectionModel.Item)
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
            case .modelSelected(let article):
                return .empty()
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
            return [.basic(items: articles)]
        }
    }
}
