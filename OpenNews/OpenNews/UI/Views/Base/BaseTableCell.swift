//
//  BaseTableCell.swift
//  OpenNews
//
//  Created by Taeyoung Son on 2022/10/22.
//

import UIKit

import RxSwift

class RxBaseTableCell: UITableViewCell, CodeBaseType, RxBindable {
    var disposeBag: DisposeBag = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addSubviews() { }
    func addConstraints() { }
    func setAttrs() { }
    func bind() { }
    func clearBag() {
        self.disposeBag = .init()
    }
}
