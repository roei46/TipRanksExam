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
        //MARK - Go to webView with link from vm
        vm.onNext.drive(onNext: { [weak self] link in
            guard let self = self else { return }
            self.showWebView(with: link)
        })
        .disposed(by: vm.disposeBag)
        
        //MARK - show error
        vm.onError.drive(onNext: { [weak self] error in
            guard let self = self else { return }
            if let errorCode = error as NSError? {
                if errorCode.code != 10 {
                    self.showAlert()
                }
            }
        })
        .disposed(by: vm.disposeBag)
        
    
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.viewModel = vm
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MainCoordinator {
    func showWebView(with link: String) {
        if link == "https://www.tipranks.com/" {
            if let url = URL(string: link) {
                UIApplication.shared.open(url)
            }
        } else {
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.link = link
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Oh No!!", message: "There is an error!", preferredStyle: .alert)
        self.navigationController.present(alertController, animated: true, completion: nil)
    }
}
