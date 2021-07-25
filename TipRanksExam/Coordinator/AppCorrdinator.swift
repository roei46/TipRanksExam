//
//  AppCorrdinator.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 20/07/2021.
//

import Foundation
import UIKit

final class AppCorrdinator: Coordinator {
    var window: UIWindow
    lazy private var mainCoordinator: MainCoordinator = {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return MainCoordinator(navigationController: navigationController)
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        mainCoordinator.start()
    }
}
