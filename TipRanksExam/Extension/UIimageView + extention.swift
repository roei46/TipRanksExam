//
//  UIimageView + extention.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 23/07/2021.
//

import Foundation
import UIKit

extension UIImageView {
    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
