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
//    let spinner = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        tableView.register(UINib(nibName: "PromotionTableViewCell", bundle: nil), forCellReuseIdentifier: "PromotionTableViewCell")
        
        bindRx()
        addFotter()
    }
    
    func bindRx() {
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
                cell.background.sd_setImage(with: URL(string: vm.imageUrl), completed: nil)
                cell.authorImage.sd_setImage(with: URL(string: vm.authorImageUrl), completed: nil)
//                    background.sd_setImage(with: URL(string: viewModel.imageUrl), completed: nil)
//                    authorImage.sd_setImage(with: URL(string: viewModel.authorImageUrl), completed: nil)
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
        
        tableView.rx
            .modelSelected(CellType.self)
            .bind(to: viewModel.selectedCell)
            .disposed(by: disposeBag)
        
        
//        tableView.rx
//            .willDisplayCell
//            .subscribe(onNext: { cell, indexPath in
//                let lastItem = self.viewModel.counter - 1
//                if indexPath.row == lastItem {
//                    self.viewModel.loadMore.accept(())
//                }
//            })
//            .disposed(by: disposeBag)
        
        tableView.rx
            .reachedBottom()
            .debug("botoom!!!!!!!!!")
            .bind(to: self.viewModel.loadMore)
            .disposed(by: disposeBag)
    }
    
    func addFotter() {

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        footerView.backgroundColor = UIColor.yellow
        let labelFooter = UILabel(frame: footerView.frame)
        labelFooter.text = "Footer view label text."
        labelFooter.textColor = .red
        footerView.addSubview(labelFooter)
        tableView.tableFooterView = footerView

    }
}

public extension Reactive where Base: UIScrollView {
    /**
     Shows if the bottom of the UIScrollView is reached.
     - parameter offset: A threshhold indicating the bottom of the UIScrollView.
     - returns: ControlEvent that emits when the bottom of the base UIScrollView is reached.
     */
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
