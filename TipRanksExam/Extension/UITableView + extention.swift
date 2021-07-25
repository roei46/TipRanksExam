//
//  UITableView + extention.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 25/07/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    public var animation: Binder<Bool> {
        return Binder(self.base) { hud, show in
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: hud.bounds.width, height: CGFloat(44))
            hud.tableFooterView = spinner
            if show {
                hud.tableFooterView?.isHidden = true
            } else {
                hud.tableFooterView?.isHidden = false
                hud.reloadData()
            }
        }
    }
}
