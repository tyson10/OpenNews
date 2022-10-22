//
//  UITableViewCell+Extension.swift
//  OpenNews
//
//  Created by Taeyoung Son on 2022/10/22.
//

import UIKit

extension UITableViewCell {
    static var reuseableIdentifier: String {
        get {
            return NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
        }
    }
}
