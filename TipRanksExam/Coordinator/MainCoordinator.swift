//
//  MainCoordinator.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 20/07/2021.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    let navigationController: UINavigationController
    let vm = PostsViewModel()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        vm.onNext.drive(onNext: { [weak self] link in
            guard let self = self else { return }
            self.showWebView(with: link)
        })
        .disposed(by: vm.disposeBag)
    
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.viewModel = vm
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MainCoordinator {
    func showWebView(with link: String) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.link = link
        self.navigationController.pushViewController(vc, animated: true)
    }
}
