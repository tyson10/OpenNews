//
//  ArticleListTableCell.swift
//  OpenNews
//
//  Created by Taeyoung Son on 2022/10/22.
//

import UIKit

import SnapKit

extension ArticleListVC {
    final class TableCell: RxBaseTableCell<SectionModel.Item> {
        private let articleImgView = UIImageView()
        private let titleLabel = UILabel()
        
        override func addSubviews() {
            self.contentView.addSubview(self.articleImgView)
            self.contentView.addSubview(self.titleLabel)
        }
        
        override func addConstraints() {
            self.articleImgView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(30)
                $0.centerY.equalToSuperview()
                $0.height.width.equalTo(80)
            }
            
            self.titleLabel.snp.makeConstraints { [weak self] in
                guard let self = self else { return }
                $0.leading.equalTo(self.articleImgView.snp.trailing)
                $0.trailing.equalToSuperview().inset(30)
                $0.centerY.equalToSuperview()
            }
        }
        
        override func setAttrs() {
            super.setAttrs()
        }
        
        override func configure(with item: SectionModel.Item) {
            self.titleLabel.text = item.title
            if let path = item.imagePath {
                self.articleImgView.setImage(with: path)
            }
        }
    }
}
