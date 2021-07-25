//
//  Coordinator.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 20/07/2021.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
