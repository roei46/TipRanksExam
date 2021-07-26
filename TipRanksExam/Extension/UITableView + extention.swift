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
    var animation: Binder<NetworkState> {
        return Binder(self.base) { hud, state in
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: hud.bounds.width, height: CGFloat(44))
            switch state {
            case .footer:
                let footerView = UIView(frame: CGRect(x: 0, y: 0, width: hud.frame.size.width, height: 40))
                footerView.backgroundColor = .red
                let labelFooter = UILabel(frame: footerView.frame)
                labelFooter.text = " End of the list! "
                labelFooter.textColor = .black
                footerView.addSubview(labelFooter)
                hud.tableFooterView = footerView
            case .loading:
                hud.tableFooterView = spinner
                hud.tableFooterView?.isHidden = true
            case .notLoading:
                hud.tableFooterView?.isHidden = false
                hud.reloadData()
            }
        }
    }
}
