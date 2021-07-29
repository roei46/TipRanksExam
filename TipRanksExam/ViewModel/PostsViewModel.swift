//
//  PostsViewModel.swift
//  TipRanksExam
//
//  Created by Roei Baruch on 25/07/2021.on 22/07/2021.
//

import Foundation
import RxSwift
import RxCocoa

enum NetworkState {
    case loading
    case notLoading(endOfTheList: Bool)
}

enum CellType {
    case post(model: PostTableViewCellViewModel)
    case promotion(title: String)
}

final class PostsViewModel {
    
    let disposeBag = DisposeBag()
    private var networking: Networking!
    private var deltaItemsCount: [Post]?
    //Inputs
    var searchButtonTapped = PublishRelay<Void>()
    var searchText = PublishRelay<String>()
    var loadMore = PublishRelay<Void>()
    var selectedCell = PublishRelay<CellType>()
    
    //Outputs
    var itemsDriver: Driver<[CellType]>!
    var isLoadingState = PublishRelay<NetworkState>()
    var isLoading: Driver<NetworkState>!
    private let _onNext = PublishRelay<String>()
    lazy var onNext = _onNext.asDriver(onErrorDriveWith: .never())
    
    private var _onError: Observable<Error>!
    lazy var onError = _onError.asDriver(onErrorDriveWith: .never())
    
    private var needReset = false
    private var page = 1
    var counter = 0
    private var params = [ "page": 1,
                           "per_page": 20,
                           "search": ""] as [String : Any]
    
    init(networking: Networking = Networking()) {
        self.networking = networking
        
        //MARK -  Now what to do if selected item
        selectedCell.subscribe(onNext: { item in
            var link = ""
            switch item {
            case .post(model: let vm):
                link = vm.link
            case .promotion(title: _):
                link = "https://www.tipranks.com/"
            }
            self._onNext.accept(link)
        }).disposed(by: disposeBag)
        
        searchButtonTapped.subscribe(onNext: { [weak self] value in
            self?.page = 0
            self?.counter = 0
            self?.needReset = true
            print("load more pushed 🛵")
            self?.loadMore.accept(())
        }).disposed(by: disposeBag)
        
        searchText.subscribe(onNext: { [weak self] value in
            self?.params.updateValue(value, forKey: "search")
        }).disposed(by: disposeBag)
        
        
        let page = loadMore.scan(0) { (value, _) -> Int in
            self.page = self.page + 1
            self.params.updateValue(self.page, forKey: "page")
            return value + 1
        }
        
        let posts = page
            .flatMapLatest { page in
                self.networking.preformNetworkTaskGet(
                    endPoint: Api.get,
                    type: Posts.self,
                    methodType: .get,
                    param: self.params)
                    .materialize()
            }
            .share()
        
        let scan = posts.scan(into: [Post]()) { current, items in
            if let itemsArray = items.element?.data {
                self.deltaItemsCount = itemsArray
            }
            
            if self.needReset {
                current = [Post]()
                self.needReset = false
            }
            guard let element = items.element?.data else { return }
            current.append(contentsOf: element)
            self.counter = current.count
        }
        .share()
        
        _onError = posts
            .compactMap {
                $0.error
            }
        
        //MARK - if error  == 10 show footer
        _onError.subscribe(onNext: { error in
            if let errortest = error as NSError? {
                if errortest.code == 10 {
                    self.isLoadingState.accept(.notLoading(endOfTheList: true))
                }
            }
        }).disposed(by: disposeBag)
        
        let vm = scan.map {
            self.postsToCellViewModel(posts: $0)
        }
        
        itemsDriver = vm
            .map { $0 }
            .asDriver(onErrorJustReturn: [])
        
        isLoading = Observable.merge(
            page.map { _ in .loading },
            vm.map { _ in
                self.deltaItemsCount?.count ?? 0 < 20 ? .notLoading(endOfTheList: true) : .notLoading(endOfTheList: false)
            }
        )
        .asDriver(onErrorJustReturn: .notLoading(endOfTheList: false))
    }
    
    private func postsToCellViewModel(posts: [Post]) -> [CellType] {
        //MARK - Add cells every 10 cells
        var cellViewModelArray = [CellType]()
        if posts.count > 0 {
            for (index, object) in posts.enumerated() {
                if index % 10  == 3 {
                    cellViewModelArray.append( CellType.promotion(title: "Promotion"))
                } else {
                    let vm = PostTableViewCellViewModel(post: object)
                    cellViewModelArray.append(CellType.post(model: vm))
                }
            }
        } else {
            cellViewModelArray.append( CellType.promotion(title: "No data! - please try again"))
        }
        
        return cellViewModelArray
    }
}
