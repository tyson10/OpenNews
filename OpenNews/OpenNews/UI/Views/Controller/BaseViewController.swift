//
//  BaseViewController.swift
//  OpenNews
//
//  Created by Taeyoung Son on 2022/10/15.
//

import UIKit

import RxSwift
import ReactorKit

protocol CodeBaseType {
    func setup()
    func addSubviews()
    func addConstraints()
    func setAttrs()
}

extension CodeBaseType {
    func setup() {
        self.addSubviews()
        self.addConstraints()
        self.setAttrs()
    }
}

protocol RxBaseType {
    var disposeBag: DisposeBag { get set }
    func clearBag()
}

class ReactorBaseController<T: ReactorKit.Reactor>: UIViewController, CodeBaseType, ReactorKit.View, RxBaseType {
    typealias Reactor = T
    var disposeBag: DisposeBag = .init()
    
    init(reactor: T? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.setup()
        self.reactor = reactor
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addSubviews() { }
    func addConstraints() { }
    func setAttrs() { }
    func bind(reactor: T) { }
    func clearBag() {
        self.disposeBag = .init()
    }
}
