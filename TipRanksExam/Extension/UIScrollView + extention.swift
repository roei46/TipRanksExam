//
//  UIScrollView + extention.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

public extension Reactive where Base: UIScrollView {

    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { contentOffset in
            let visibleHeight = self.base.frame.height - self.base.contentInset.top - self.base.contentInset.bottom
            let y = contentOffset.y + self.base.contentInset.top
            let threshold = max(offset, self.base.contentSize.height - visibleHeight)
            return y >= threshold
        }
        .distinctUntilChanged()
        .filter { $0 }
        .map { _ in () }
        return ControlEvent(events: source)
    }
}