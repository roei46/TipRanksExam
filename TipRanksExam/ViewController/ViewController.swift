//
//  ViewController.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 25/07/2021.
//

import UIKit
import MBProgressHUD
import RxSwift
import RxCocoa
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn: UIButton!
    var viewModel: PostsViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        tableView.register(UINib(nibName: "PromotionTableViewCell", bundle: nil), forCellReuseIdentifier: "PromotionTableViewCell")
        self.navigationItem.title = "Welcome!"
        bindRx()
    }
    
    func bindRx() {
        
        searchField.rx
            .cancelButtonClicked
            .subscribe(onNext: {
                self.searchField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        searchField.rx
            .searchButtonClicked
            .subscribe(onNext: {
                self.searchField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        btn.rx
            .tap
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: disposeBag)
        
        searchField.rx
            .text
            .orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        searchField.rx
            .searchButtonClicked
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.itemsDriver.drive(tableView.rx.items) { (tableView, row, element) -> UITableViewCell in
            
            switch element {
            case .post(model: let vm):
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
                cell.config(viewModel: vm)
                cell.setNeedsLayout()
                return cell
                
            case .promotion(title: _):
                let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionTableViewCell") as! PromotionTableViewCell
                return cell
            }
        }.disposed(by: disposeBag)
        
        viewModel
            .isLoading
            .drive(tableView.rx.animation)
            .disposed(by: disposeBag)
        
        viewModel.isLoadingState
            .bind(to: tableView.rx.animation)
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(CellType.self)
            .bind(to: viewModel.selectedCell)
            .disposed(by: disposeBag)
        //MARK - Second way to know the end of the tableView
        
//        tableView.rx
//            .reachedBottom()
//            .skip(1)
//            .bind(to: self.viewModel.loadMore)
//            .disposed(by: disposeBag)
        
                tableView.rx
                    .willDisplayCell
                    .subscribe(onNext: { cell, indexPath in
                        let lastItem = self.viewModel.counter - 1
                        if indexPath.row == lastItem {
                             self.viewModel.loadMore.accept(())
                        }
                    })
                    .disposed(by: disposeBag)
    }
}
