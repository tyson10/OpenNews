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
            case reload
            case modelSelected(SectionModel.Item)
        }
        
        enum Mutation {
            case setSectionDatas([SectionModel])
            case setIsReloadEnded(Bool)
        }
        
        struct State {
            @Pulse var sectionDatas = [SectionModel]()
            @Pulse var isReloadEnded = true
        }
        
        func mutate(action: Action) -> Observable<Mutation> {
            var result: Observable<Mutation>
            var mutations = [Observable<Mutation>]()
            
            switch action {
            case .loadArticles:
                let sectionDatas = API.fetchAllArticles().map(self.makeSectionDatas(with:))
                result = sectionDatas.map(Mutation.setSectionDatas)
                
            case .reload:
                mutations.append(.of(.setIsReloadEnded(false)))
                mutations.append(API.fetchAllArticles().map(self.makeSectionDatas(with:)).map(Mutation.setSectionDatas))
                mutations.append(.of(.setIsReloadEnded(true)))
                result = .concat(mutations)
                
            case .modelSelected(let article):
                result = .empty()
            }
            
            return result
        }
        
        func reduce(state: State, mutation: Mutation) -> State {
            var new = state
            
            switch mutation {
            case .setSectionDatas(let sectionDatas):
                new.sectionDatas = sectionDatas
            case .setIsReloadEnded(let flag):
                new.isReloadEnded = flag
            }
            
            return new
        }
        
        private func makeSectionDatas(with articles: [Article]) -> [SectionModel] {
            return [.basic(items: articles)]
        }
    }
}
